//
//  NSErrorExtensions.swift
//  Action
//
//  Created by Dao Duy Duong on 9/25/18.
//

import UIKit

extension NSError {
    
    private static var domain: String {
        return Bundle.main.bundleIdentifier ?? "dd.mvvm.error"
    }
    
    public static var unknown: NSError {
        return NSError(domain: domain, code: 1000, userInfo: [NSLocalizedDescriptionKey : "Unknown error occurrs."])
    }
    
}

