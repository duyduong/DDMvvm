//
//  Global.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/18/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

// MARK: - Enums

public enum ComponentViewPosition {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat), center
}

public enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

public enum ApplicationState {
    case none, resignActive, didEnterBackground, willEnterForeground, didBecomeActive, willTerminate
}

public enum HttpContentType: String {
    case json = "application/json"
    case xml = "text/xml"
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

public struct HttpSettings {
    
    var httpContentType: HttpContentType
    var requestTimeout: TimeInterval
}

public typealias TopPageFindingBlock = (() -> UIViewController?)

// block to find top page in window
var topPageFindingBlock: TopPageFindingBlock = {
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

// default http settings
var httpSettings: HttpSettings = HttpSettings(httpContentType: .json, requestTimeout: 15)

// MARK: Global functions

public func setTopPageFindingBlock(_ block: @escaping TopPageFindingBlock) {
    topPageFindingBlock = block
}

public func configureHttpSettings(_ settings: HttpSettings) {
    httpSettings = settings
}














