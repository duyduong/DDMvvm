//
//  Global.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public enum ComponentViewPosition {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat), center
}

/// ViewState for binding from ViewModel and View (Life cycle binding)
public enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

/// ApplicationState for anyone who wants to know the application state
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

/// Block type for searching top page
public typealias SearchTopPageBlock = (() -> UIViewController?)

/// Block type for destroy a page (mainly to clean up DisposeBag)
public typealias DestroyPageBlock = ((UIViewController?) -> ())

/*
 Global configurations
 For some use cases, we have to setup these configurations to make our application work
 correctly
 */
public struct DDConfigurations {
    
    /*
     Block for searching top page in our main window
     If your rootViewController is a custom one (such as Drawer...)
     then override this block to make navigation service can find the correct top page
     */
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
    
    /*
     Block for destroying a page (mainly clean up DisposeBag), using for navigation service
     If you have a custom page more than UINavigationController and UITabBarController,
     then override this block for your customs
     */
    public static var destroyPageBlock: DestroyPageBlock = { page in
        var viewControllers = [UIViewController]()
        if let navPage = page as? UINavigationController {
            viewControllers = navPage.viewControllers
        }
        
        if let tabPage = page as? UITabBarController {
            viewControllers = tabPage.viewControllers ?? []
        }
        
        // recursively call destroy on child viewcontrollers
        viewControllers.forEach { DDConfigurations.destroyPageBlock($0) }
        
        // destroy current page
        (page as? IDestroyable)?.destroy()
        
        // remove animator delegate
        (page as? ITransitionView)?.animatorDelegate = nil
    }
}



















