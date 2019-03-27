//
//  UINavigationControllerExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension UINavigationController {
    
    public func popViewController(animated: Bool, completions: ((UIViewController?) -> Void)?) {
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
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completions: (() -> Void)?) {
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

