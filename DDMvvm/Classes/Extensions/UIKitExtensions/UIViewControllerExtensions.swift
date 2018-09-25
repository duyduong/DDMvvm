//
//  UINavigationControllerExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 1/9/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func popViewController(animated: Bool, completions: ((UIViewController?) -> Void)?) {
        let page = topViewController
        
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completions?(page) }
            popViewController(animated: animated)
            CATransaction.commit()
        } else {
            popViewController(animated: animated)
            completions?(page)
        }
        
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completions: (() -> Void)?) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completions)
            pushViewController(viewController, animated: animated)
            CATransaction.commit()
        } else {
            popViewController(animated: animated)
            completions?()
        }
    }
    
}

