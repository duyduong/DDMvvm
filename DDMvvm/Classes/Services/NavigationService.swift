//
//  NavigationService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit

public enum PushType {
    case auto(animated: Bool, animator: Animator?)
    case push(animated: Bool, animator: Animator?)
    case modally(presentationStyle: UIModalPresentationStyle, animated: Bool, animator: Animator?)
    case popup(shouldDismissOnTapOutside: Bool, overlayColor: UIColor)
}

public enum PopType {
    case auto(animated: Bool)
    case pop(animated: Bool)
    case popToRoot(animated: Bool)
    case popTo(index: Int, animated: Bool)
    case dismiss(animated: Bool)
    case dismissPopup
}

public protocol INavigationService {
    
    func push(to page: UIViewController, type: PushType, completion: (() -> Void)?)
    func pop(with type: PopType, completion: (() -> Void)?)
}

extension INavigationService {
    
    public func push(to page: UIViewController, type: PushType = .auto(animated: true, animator: nil), completion: (() -> Void)? = nil) {
        push(to: page, type: type, completion: completion)
    }
    
    public func pop(with type: PopType = .auto(animated: true), completion: (() -> Void)? = nil) {
        pop(with: type, completion: completion)
    }
}

public class NavigationService: INavigationService {
    
    private var topPage: UIViewController? {
        return DDConfigurations.topPageFindingBlock.create()
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, type: PushType, completion: (() -> Void)? = nil) {
        guard let topPage = topPage else { return }
        
        let handlePush = { (animated: Bool, animator: Animator?) in
            if let animator = animator {
                // attach animtor to destination page
                (page as? ITransitionView)?.animatorDelegate = AnimatorDelegate(withAnimator: animator)
            }
            
            DDConfigurations.beforePush?()
            topPage.navigationController?.pushViewController(page, animated: animated, completions: completion)
        }
        
        let handleModal = { (presentationStyle: UIModalPresentationStyle, animated: Bool, animator: Animator?) in
            if let animator = animator {
                let delegate = AnimatorDelegate(withAnimator: animator)
                (page as? ITransitionView)?.animatorDelegate = delegate
                page.transitioningDelegate = delegate
                page.modalPresentationStyle = .custom
            } else {
                page.modalPresentationStyle = presentationStyle
            }
            
            DDConfigurations.beforePresent?()
            topPage.present(page, animated: animated, completion: completion)
        }
        
        switch type {
        case .auto(let animated, let animator):
            if topPage.navigationController != nil {
                handlePush(animated, animator)
            } else {
                handleModal(.fullScreen, animated, animator)
            }
            
        case .push(let animated, let animator):
            handlePush(animated, animator)
            
        case .modally(let presentationStyle, let animated, let animator):
            handleModal(presentationStyle, animated, animator)
            
        case .popup(let shouldDismissOnTapOutside, let overlayColor):
            let presenterPage = PresenterPage(contentPage: page)
            presenterPage.shouldDismissOnTapOutside = shouldDismissOnTapOutside
            presenterPage.overlayColor = overlayColor
            presenterPage.showCompletion = completion
            presenterPage.modalPresentationStyle = .overFullScreen
            topPage.present(presenterPage, animated: false)
        }
    }
    
    // MARK: - Pop functions
    
    public func pop(with type: PopType, completion: (() -> Void)? = nil) {
        guard let topPage = topPage else { return }
        
        let destroyPageBlock = DDConfigurations.destroyPageBlock
        let handleDismiss = { (animated: Bool) in
            topPage.dismiss(animated: animated) {
                destroyPageBlock(topPage)
                destroyPageBlock(topPage.navigationController)
                destroyPageBlock(topPage.tabBarController)
                
                completion?()
            }
        }
        
        switch type {
        case .auto(let animated):
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: animated) {
                    destroyPageBlock($0)
                    completion?()
                }
            } else {
                handleDismiss(animated)
            }
            
        case .pop(let animated):
            topPage.navigationController?.popViewController(animated: animated) {
                destroyPageBlock($0)
                completion?()
            }
            
        case .popToRoot(let animated):
            topPage.navigationController?.popToRootViewController(animated: animated) { pages in
                pages?.forEach { destroyPageBlock($0) }
                completion?()
            }
            
        case .popTo(let index, let animated):
            topPage.navigationController?.popToViewController(at: index, animated: animated) { pages in
                pages?.forEach { destroyPageBlock($0) }
                completion?()
            }
            
        case .dismiss(let animated):
            handleDismiss(animated)
            
        case .dismissPopup:
            let presenterPage = topPage.navigationController?.parent ?? topPage.tabBarController?.parent ?? topPage.parent ?? topPage
            presenterPage.dismiss(animated: false, completion: completion)
        }
    }
}






