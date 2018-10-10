//
//  NavigationService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit

public enum PushType {
    case auto, push, modally(UIModalPresentationStyle)
}

public enum PopType {
    case auto, pop, dismiss
}

public struct PushOptions {
    
    public let pushType: PushType
    public let animator: Animator?
    public let animated: Bool
    
    public init(pushType: PushType = .auto, animator: Animator? = nil, animated: Bool = true) {
        self.pushType = pushType
        self.animator = animator
        self.animated = animated
    }
    
    public static var defaultOptions: PushOptions {
        return PushOptions()
    }
    
    public static func pushWithAnimator(_ animator: Animator) -> PushOptions {
        return PushOptions(pushType: .push, animator: animator)
    }
    
    public static func modalWithAnimator(_ animator: Animator, presentationStyle: UIModalPresentationStyle = .custom) -> PushOptions {
        return PushOptions(pushType: .modally(presentationStyle), animator: animator)
    }
}

public struct PopOptions {
    
    public let popType: PopType
    public let animated: Bool
    
    public init(popType: PopType = .auto, animated: Bool = true) {
        self.popType = popType
        self.animated = animated
    }
    
    public static var defaultOptions: PopOptions {
        return PopOptions()
    }
}

public protocol INavigationService {
    
    func push(to page: UIViewController, options: PushOptions)
    func pop(with options: PopOptions)
}

extension INavigationService {
    
    public func push(to page: UIViewController, options: PushOptions = .defaultOptions) {
        push(to: page, options: options)
    }
    
    public func pop(with options: PopOptions = .defaultOptions) {
        pop(with: options)
    }
}

public class NavigationService: INavigationService {
    
    private var topPage: UIViewController? {
        return DDConfigurations.topPageFindingBlock()
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, options: PushOptions) {
        guard let topPage = topPage else { return }
        
        let handlePush = {
            if let animator = options.animator {
                // attach animtor to destination page
                (page as? ITransitionView)?.animatorDelegate = AnimatorDelegate(withAnimator: animator)
            }
            
            topPage.navigationController?.pushViewController(page, animated: options.animated)
        }
        
        let handleModal = { (presentationStyle: UIModalPresentationStyle) in
            if let animator = options.animator {
                let delegate = AnimatorDelegate(withAnimator: animator)
                (page as? ITransitionView)?.animatorDelegate = delegate
                page.transitioningDelegate = delegate
                page.modalPresentationStyle = presentationStyle
            }
            
            topPage.present(page, animated: options.animated, completion: nil)
        }
        
        switch options.pushType {
        case .auto:
            if topPage.navigationController != nil {
                handlePush()
            } else {
                handleModal(.custom)
            }
            
        case .push: handlePush()
            
        case .modally(let presentationStyle): handleModal(presentationStyle)
        }
    }
    
    // MARK: - Pop functions
    
    public func pop(with options: PopOptions) {
        guard let topPage = topPage else { return }
        
        let handleDismiss = {
            topPage.dismiss(animated: options.animated) {
                let destroyPageBlock = DDConfigurations.destroyPageBlock
                
                destroyPageBlock(topPage)
                destroyPageBlock(topPage.navigationController)
                destroyPageBlock(topPage.tabBarController)
            }
        }
        
        switch options.popType {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: options.animated) { DDConfigurations.destroyPageBlock($0) }
            } else {
                handleDismiss()
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: options.animated) { DDConfigurations.destroyPageBlock($0) }
            
        case .dismiss:
            handleDismiss()
        }
    }
}






