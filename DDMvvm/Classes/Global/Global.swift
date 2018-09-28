//
//  Global.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/18/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

public enum ComponentViewPosition {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat), center
}

public enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

public enum ApplicationState {
    case none, resignActive, didEnterBackground, willEnterForeground, didBecomeActive, willTerminate
}

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

public struct InlineLoaderViewSettings {
    
    let indicatorColor: UIColor
    let textColor: UIColor
    let loadingText: String
    let font: UIFont
}

/// Block type for searching top page and destroy page
public typealias SearchTopPageBlock = (() -> UIViewController?)
public typealias DestroyPageBlock = ((UIViewController?) -> ())

/// Some global settings for the whole framework
public struct DDConfigurations {
    
    /// Block for searching top page in our main window
    public static var topPageFindingBlock: SearchTopPageBlock = {
        let myWindow = UIApplication.shared.windows
            .filter { !($0.rootViewController is UIAlertController) }
            .first
        
        guard let rootPage = myWindow?.rootViewController else {
            return nil
        }
        
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
    
    /// Block for destroying a page, using for navigation service
    public static var destroyPageBlock: DestroyPageBlock = { page in
        var viewControllers = [UIViewController]()
        if let navPage = page as? UINavigationController {
            viewControllers = navPage.viewControllers
        }
        
        if let tabPage = page as? UITabBarController {
            viewControllers = tabPage.viewControllers ?? []
        }
        
        viewControllers.forEach { destroyPage($0) }
        (page as? IDestroyable)?.destroy()
        (page as? ITransionView)?.animatorDelegate = nil
    }
    
    private static func destroyPage(_ page: UIViewController?) {
        destroyPageBlock(page)
    }
    
    /// Settings for inline loader view
    public static var inlineLoaderViewSettings = InlineLoaderViewSettings(indicatorColor: .black, textColor: .lightGray, loadingText: "LOADING", font: Font.system.normal(withSize: 15))
}



















