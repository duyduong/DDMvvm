//
//  NavigationService.swift
//  eSportLive
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit

public enum PushType {
    case auto, push, modally, popup(type: PopupType)
}

public enum PopType {
    case auto, pop, dismiss
}

public protocol INavigationService {
    func push(to page: UIViewController, type: PushType, animated: Bool)
    func push(to page: UIViewController, type: PushType)
    func push(to page: UIViewController)
    
    func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController, navigationWrapper: Bool)
    func push(with transitioningDelegate: TransitioningDelegate, to page: UIViewController)
    
    func pop(for type: PopType, animated: Bool)
    func pop(for type: PopType)
    func pop()
}

public class NavigationService: INavigationService {
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    private var rootPage: UIViewController? {
        get { return keyWindow?.rootViewController }
        set { keyWindow?.rootViewController = newValue }
    }
    
    private var topPage: UIViewController? {
        guard let rootPage = rootPage else { return nil }
        
        var currPage: UIViewController? = rootPage.presentedViewController ?? rootPage
        while currPage?.presentedViewController != nil {
            currPage = currPage?.presentedViewController
        }
        
        while currPage is UINavigationController || currPage is UITabBarController {
            if let navPage = currPage as? UINavigationController {
                currPage = navPage.viewControllers.last
            }
            
            if let tabPage = currPage as? UITabBarController {
                currPage = tabPage.selectedViewController
            }
        }
        
        return currPage
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
        (page as? Destroyable)?.destroy()
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
            
        case .popup(let type):
            let popupPage = BasePopupPage(contentPage: page, popupType: type)
            popupPage.modalPresentationStyle = .overFullScreen
            topPage.present(popupPage, animated: false)
        }
    }
    
    public func push(to page: UIViewController, type: PushType) {
        push(to: page, type: type, animated: true)
    }
    
    public func push(to page: UIViewController) {
        push(to: page, type: .auto, animated: true)
    }
    
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






