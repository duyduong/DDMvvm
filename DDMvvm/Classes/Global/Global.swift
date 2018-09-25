//
//  Global.swift
//  mvvm-scaffold
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

enum HttpContentType {
    case json, xml
}

public struct Configs {
    
    static let httpContentType: HttpContentType = .json
    
    static let requestTimeout: TimeInterval = 15
    
}
















