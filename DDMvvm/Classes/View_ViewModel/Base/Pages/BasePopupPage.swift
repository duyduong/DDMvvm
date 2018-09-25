//
//  PopupView.swift
//  phimbo
//
//  Created by Dao Duy Duong on 9/20/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift

public enum PopupType {
    case popup, picker
    
    var showDuration: Double {
        switch self {
        case .popup: return 0.7
        case .picker: return 0.4
        }
    }
    
    var dismissDuration: Double {
        switch self {
        case .popup: return 0.25
        case .picker: return 0.4
        }
    }
}

class BasePopupPage: UIViewController {
    
    fileprivate var contentPage: UIViewController!
    fileprivate var overlayView: OverlayView!
    
    fileprivate var disposeBag: DisposeBag! = DisposeBag()
    
    fileprivate var heightConstraint: NSLayoutConstraint!
    fileprivate var widthConstraint: NSLayoutConstraint!
    
    var popupType: PopupType = .popup
    
    init(contentPage: UIViewController, popupType: PopupType = .popup) {
        self.contentPage = contentPage
        self.popupType = popupType
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
            heightConstraint = contentPage.view.autoSetDimension(.height, toSize: 480)
            
        case .picker:
            contentPage.view.setShadow(offset: CGSize(width: 0, height: -5), color: .black, opacity: 0.3, blur: 5)
            contentPage.view.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
            contentPage.view.transform = CGAffineTransform(translationX: 0, y: 600)
        }
        
        contentPage.didMove(toParent: self)
        
        overlayView.rx.tapGesture.subscribe(onNext: { _ in
            self.dismiss(animated: false)
        }) => disposeBag
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
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    func destroy() {
        (contentPage as? Destroyable)?.destroy()
        disposeBag = nil
        
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
                self.contentPage.view.transform = CGAffineTransform.identity
            }, completion: nil)
            
        case .picker:
            UIView.animate(withDuration: popupType.showDuration) {
                self.overlayView.alpha = 1
                self.contentPage.view.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    private func adjustContainerSize() {
        switch popupType {
        case .popup:
            let maxWidth = view.frame.size.width - 40
            let maxHeight = view.frame.size.height - 80
            
            let contentSize = contentPage.preferredContentSize
            var width: CGFloat = maxWidth
            var height: CGFloat = maxHeight
            if contentSize.width > 0 && contentSize.width < width {
                width = contentSize.width
            }
            if contentSize.height > 0 && contentSize.height < height {
                height = contentSize.height
            }
            
            widthConstraint.constant = width
            heightConstraint.constant = height
            view.layoutIfNeeded()
            
        case .picker:
            if contentPage.view.isHidden {
                contentPage.view.transform = CGAffineTransform(translationX: 0, y: contentPage.view.frame.size.height)
            }
        }
    }
    
}
