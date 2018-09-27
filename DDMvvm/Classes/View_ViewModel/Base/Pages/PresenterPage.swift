//
//  PopupView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/20/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift
import Action

class PresenterPage: UIViewController, IDestroyable {
    
    private var contentPage: UIViewController!
    private var overlayView: OverlayView!
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    var popupType: PopupType = .popup
    var shouldDismissOnTapOutside: Bool = true
    
    private lazy var tapAction: Action<Void, Void> = {
        return Action() {
            if self.shouldDismissOnTapOutside {
                self.dismiss(animated: false)
            }
            
            return .just(())
        }
    }()
    
    init(contentPage: UIViewController, popupType: PopupType = .popup, shouldDismissOnTapOutside: Bool = true) {
        self.contentPage = contentPage
        self.popupType = popupType
        self.shouldDismissOnTapOutside = shouldDismissOnTapOutside
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        
        overlayView = OverlayView.addToPage(self)
        overlayView.alpha = 0
        
        addChild(contentPage)
        view.addSubview(contentPage.view)
        contentPage.view.isHidden = true
        
        switch popupType {
        case .popup:
            contentPage.view.transform = CGAffineTransform(scaleX: 0, y: 0)
            contentPage.view.cornerRadius = 7
            contentPage.view.autoCenterInSuperview()
            widthConstraint = contentPage.view.autoSetDimension(.width, toSize: 320)
            
        case .picker:
            contentPage.view.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
            contentPage.view.setShadow(offset: CGSize(width: 0, height: -5), color: .black, opacity: 0.3, blur: 5)
        }
        heightConstraint = contentPage.view.autoSetDimension(.height, toSize: 480)
        contentPage.didMove(toParent: self)
        
        overlayView.tapGesture.bind(to: tapAction, input: ())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adjustContainerSize()
        show()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.adjustContainerSize()
        }, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: popupType.dismissDuration, animations: {
            self.overlayView.alpha = 0
            
            switch self.popupType {
            case .popup:
                self.contentPage.view.alpha = 0
                self.contentPage.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
            case .picker:
                self.contentPage.view.transform = CGAffineTransform(translationX: 0, y: self.contentPage.view.frame.size.height)
            }
            
        }) { _ in
            super.dismiss(animated: false) {
                self.destroy()
                completion?()
            }
        }
    }
    
    func destroy() {
        overlayView.tapGesture.unbindAction()
        
        (contentPage as? IDestroyable)?.destroy()
        disposeBag = DisposeBag()
        
        contentPage.view.removeFromSuperview()
        contentPage.removeFromParent()
    }
    
    // MARK: - Toggle content view
    
    private func show() {
        contentPage.view.isHidden = false
        
        switch popupType {
        case .popup:
            UIView.animate(withDuration: popupType.showDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                self.overlayView.alpha = 1
                self.contentPage.view.transform = .identity
            }, completion: nil)
            
        case .picker:
            UIView.animate(withDuration: popupType.showDuration) {
                self.overlayView.alpha = 1
                self.contentPage.view.transform = .identity
            }
        }
    }
    
    private func adjustContainerSize() {
        let contentSize = contentPage.preferredContentSize
        
        switch popupType {
        case .popup:
            let maxWidth = view.frame.width - 40
            let maxHeight = view.frame.height - 80
            
            let width = contentSize.width > 0 && contentSize.width < maxWidth ? contentSize.width : maxWidth
            let height = contentSize.height > 0 && contentSize.height < maxHeight ? contentSize.height : maxHeight
            
            widthConstraint.constant = width
            heightConstraint.constant = height
            
        case .picker:
            let maxHeight = view.frame.height / 2
            let height = contentSize.height > 0 && contentSize.height < maxHeight ? contentSize.height : maxHeight
            
            heightConstraint.constant = height
            
            if contentPage.view.isHidden {
                contentPage.view.transform = CGAffineTransform(translationX: 0, y: height)
            }
        }
        
        view.layoutIfNeeded()
    }
}
