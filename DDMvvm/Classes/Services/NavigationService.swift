//
//  NavigationService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit

public enum PushType {
    case auto, push, modally
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
    
    public static func modalWithAnimator(_ animator: Animator) -> PushOptions {
        return PushOptions(pushType: .modally, animator: animator)
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
    
    func replaceRootPage(_ page: UIViewController)
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
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.windows
            .filter { !($0.rootViewController is UIAlertController) }
            .first
    }
    
    private var topPage: UIViewController? {
        return DDConfigurations.topPageFindingBlock()
    }
    
    public func replaceRootPage(_ page: UIViewController) {
        if let myWindow = keyWindow {
            DDConfigurations.destroyPageBlock(myWindow.rootViewController)
            myWindow.rootViewController = page
        }
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, options: PushOptions) {
        guard let topPage = topPage else { return }
        
        let handlePush = {
            if let navigationPage = topPage.navigationController as? NavigationPage,
                let animator = options.animator {
                navigationPage.animatorDelegate = AnimatorDelegate(withAnimator: animator)
            }
            
            topPage.navigationController?.pushViewController(page, animated: options.animated)
        }
        
        let handleModal = {
            if let animator = options.animator {
                let delegate = AnimatorDelegate(withAnimator: animator)
                (page as? ITransionView)?.animatorDelegate = delegate
                page.transitioningDelegate = delegate
                page.modalPresentationStyle = .custom
            }
            
            topPage.present(page, animated: options.animated, completion: nil)
        }
        
        switch options.pushType {
        case .auto:
            if topPage.navigationController != nil {
                handlePush()
            } else {
                handleModal()
            }
            
        case .push: handlePush()
            
        case .modally: handleModal()
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






