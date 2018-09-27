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

public protocol INavigationService {
    
    func replaceRootPage(_ page: UIViewController)
    
    func push(to page: UIViewController, options: PushOptions)
    func push(to page: UIViewController)
    
    func pop(for type: PopType, animated: Bool)
    func pop(for type: PopType)
    func pop()
}

public class NavigationService: INavigationService {
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.windows
            .filter { !($0.rootViewController is UIAlertController) }
            .first
    }
    
    private var topPage: UIViewController? {
        return DDMvvm.topPageFindingBlock()
    }
    
    public func replaceRootPage(_ page: UIViewController) {
        if let myWindow = keyWindow {
            DDMvvm.destroyPageBlock(myWindow.rootViewController)
            myWindow.rootViewController = page
        }
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, options: PushOptions) {
        guard let topPage = topPage else { return }
        
        let handlePush = {
            if let navigationPage = topPage.navigationController as? NavigationPage {
                navigationPage.animator = options.animator
            }
            
            topPage.navigationController?.pushViewController(page, animated: options.animated)
        }
        
        let handleModal = {
            if let animator = options.animator {
                let delegate = TransitioningDelegate(withAnimator: animator)
                transitioningMap[page.description] = delegate
                
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
    
    public func push(to page: UIViewController) {
        push(to: page, options: .defaultOptions)
    }
    
    // MARK: - Pop functions
    
    public func pop(for type: PopType, animated: Bool) {
        guard let topPage = topPage else { return }
        
        let handleDismiss = {
            topPage.dismiss(animated: animated) {
                DDMvvm.destroyPageBlock(topPage)
                DDMvvm.destroyPageBlock(topPage.navigationController)
                DDMvvm.destroyPageBlock(topPage.tabBarController)
            }
        }
        
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: animated) { DDMvvm.destroyPageBlock($0) }
            } else {
                handleDismiss()
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: animated) { DDMvvm.destroyPageBlock($0) }
            
        case .dismiss:
            handleDismiss()
        }
    }
    
    public func pop(for type: PopType) {
        pop(for: type, animated: true)
    }
    
    public func pop() {
        pop(for: .auto, animated: true)
    }
    
}






