//
//  PresenterPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/20/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift
import Action

/*
 PresenterPage used for present a popup
 */
public class PresenterPage: UIViewController, IDestroyable {
    
    public override var prefersStatusBarHidden: Bool {
        return contentPage.prefersStatusBarHidden
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return contentPage.preferredStatusBarStyle
    }
    
    private let contentPage: UIViewController
    private let overlayView = OverlayView()
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    public var shouldDismissOnTapOutside: Bool = true
    
    public var overlayColor: UIColor = .clear {
        didSet { overlayView.backgroundColor = overlayColor }
    }
    
    public var showCompletion: (() -> Void)?
    
    private var isShown = false
    
    private lazy var tapAction: Action<Void, Void> = {
        return Action() {
            if self.shouldDismissOnTapOutside {
                self.dismiss(animated: false)
            }
            
            return .just(())
        }
    }()
    
    public init(contentPage: UIViewController) {
        self.contentPage = contentPage
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("PresenterPage is not for Storyboard")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        
        overlayView.alpha = 0
        overlayView.backgroundColor = overlayColor
        view.addSubview(overlayView)
        overlayView.autoPinEdgesToSuperviewEdges()
        
        contentPage.view.isHidden = true
        addChild(contentPage)
        view.addSubview(contentPage.view)
        if let popupView = contentPage as? IPopupView {
            popupView.popupLayout()
        } else {
            contentPage.view.cornerRadius = 7
            contentPage.view.autoCenterInSuperview()
            widthConstraint = contentPage.view.autoSetDimension(.width, toSize: 320)
            heightConstraint = contentPage.view.autoSetDimension(.height, toSize: 480)
        }
        
        contentPage.didMove(toParent: self)
        
        overlayView.tapGesture.bind(to: tapAction, input: ())
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.adjustContainerSize()
        }, completion: nil)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let popupView = contentPage as? IPopupView {
            popupView.hide(overlayView: overlayView) {
                super.dismiss(animated: false, completion: {
                    self.destroy()
                    completion?()
                })
            }
        } else {
            super.dismiss(animated: false, completion: {
                self.destroy()
                completion?()
            })
        }
    }
    
    public func destroy() {
        overlayView.tapGesture.unbindAction()
        
        (contentPage as? IDestroyable)?.destroy()
        disposeBag = DisposeBag()
        
        contentPage.removeFromParent()
        
        // if this presenter page is added as a child on another controller
        // then remove it
        if let _ = parent {
            removeFromParent()
        }
    }
    
    // MARK: - Toggle content view
    
    public func show() {
        if isShown { return }
        isShown = true
        
        if let popupView = contentPage as? IPopupView {
            CATransaction.begin()
            CATransaction.setCompletionBlock(showCompletion)
            popupView.show(overlayView: overlayView)
            CATransaction.commit()
        } else {
            adjustContainerSize()
            overlayView.alpha = 1
            contentPage.view.isHidden = false
            showCompletion?()
        }
    }

    private func adjustContainerSize() {
        guard widthConstraint != nil && heightConstraint != nil else { return }
        
        let contentSize = contentPage.preferredContentSize

        let maxWidth = view.frame.width - 40
        let maxHeight = view.frame.height - 80

        let width = contentSize.width > 0 && contentSize.width < maxWidth ? contentSize.width : maxWidth
        let height = contentSize.height > 0 && contentSize.height < maxHeight ? contentSize.height : maxHeight

        widthConstraint.constant = width
        heightConstraint.constant = height

        view.layoutIfNeeded()
    }
}
