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
    
    let pushType: PushType
    let animator: Animator?
    let animated: Bool
    
    public static var defaultOptions: PushOptions {
        return PushOptions(pushType: .auto, animator: nil, animated: true)
    }
    
    public static func pushWithAnimator(_ animator: Animator) -> PushOptions {
        return PushOptions(pushType: .push, animator: animator, animated: true)
    }
    
    public static func modalWithAnimator(_ animator: Animator) -> PushOptions {
        return PushOptions(pushType: .modally, animator: animator, animated: true)
    }
}

public protocol INavigationService {
    func replaceRootPage(_ page: UIViewController)
    
    func push(to page: UIViewController, type: PushType, animated: Bool)
    func push(to page: UIViewController, type: PushType)
    func push(to page: UIViewController)
    
    func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController, navigationWrapper: Bool)
    func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController)
    
    func push(to page: UIViewController, options: PushOptions)
    
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
        return topPageFindingBlock()
    }
    
    private func destroyPage(_ page: UIViewController?) {
        var viewControllers = [UIViewController]()
        if let navPage = page as? UINavigationController {
            viewControllers = navPage.viewControllers
        }
        
        if let tabPage = page as? UITabBarController {
            viewControllers = tabPage.viewControllers ?? []
        }
        
        viewControllers.forEach { destroyPage($0) }
        (page as? IDestroyable)?.destroy()
    }
    
    private static var transitionings: [UIViewController: TransitioningDelegate] = [:]
    
    public func replaceRootPage(_ page: UIViewController) {
        if let myWindow = keyWindow {
            destroyPage(myWindow.rootViewController)
            myWindow.rootViewController = page
        }
    }
    
    // MARK: - Push functions
    
    public func push(to page: UIViewController, options: PushOptions) {
        guard let topPage = topPage else { return }
        
        let handlePush = {
            if let navigationPage = topPage.navigationController as? DDNavigationPage {
                navigationPage.animator = options.animator
            }
            
            topPage.navigationController?.pushViewController(page, animated: options.animated)
        }
        
        let handleModal = {
            if let animator = options.animator {
                let delegate = TransitioningDelegate(withAnimator: animator)
                NavigationService.transitionings[page] = delegate
                
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
    
    public func push(to page: UIViewController, type: PushType, animated: Bool) {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.pushViewController(page, animated: animated)
            } else {
                topPage.present(page, animated: animated, completion: nil)
            }
            
        case .push:
            topPage.navigationController?.pushViewController(page, animated: animated)
            
        case .modally:
            topPage.present(page, animated: animated, completion: nil)
            
//        case .popup(let type):
//            let popupPage = DDPopupWrapperPage(contentPage: page, popupType: type)
//            popupPage.modalPresentationStyle = .overFullScreen
//            topPage.present(popupPage, animated: false)
        }
    }
    
    public func push(to page: UIViewController, type: PushType) {
        push(to: page, type: type, animated: true)
    }
    
    public func push(to page: UIViewController) {
        push(to: page, type: .auto, animated: true)
    }
    
    // MARK: - Push with custom animations
    
    public func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController, navigationWrapper: Bool) {
        if navigationWrapper {
            let navPage = UINavigationController(rootViewController: page)
            navPage.transitioningDelegate = transitioningDelegate
            navPage.modalPresentationStyle = .custom
            
            push(to: navPage, type: .modally)
        } else {
            page.transitioningDelegate = transitioningDelegate
            page.modalPresentationStyle = .custom
            push(to: page, type: .modally)
        }
    }
    
    public func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController) {
        push(with: transitioningDelegate, to: page, navigationWrapper: true)
    }
    
    // MARK: - Pop functions
    
    public func pop(for type: PopType, animated: Bool) {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: true) { poppedPage in
                    self.destroyPage(poppedPage)
                }
            } else {
                if let navPage = topPage.navigationController {
                    navPage.dismiss(animated: animated) { self.destroyPage(topPage) }
                } else {
                    topPage.dismiss(animated: animated) { self.destroyPage(topPage) }
                }
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: true) { poppedPage in
                self.destroyPage(poppedPage)
            }
            
        case .dismiss:
            if let navPage = topPage.navigationController {
                navPage.dismiss(animated: animated) { self.destroyPage(topPage) }
            } else {
                topPage.dismiss(animated: animated) { self.destroyPage(topPage) }
            }
        }
    }
    
    public func pop(for type: PopType) {
        pop(for: type, animated: true)
    }
    
    public func pop() {
        pop(for: .auto, animated: true)
    }
    
}






