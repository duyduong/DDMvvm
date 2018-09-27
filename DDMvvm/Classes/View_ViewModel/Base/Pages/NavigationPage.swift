//
//  NavigationPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public class NavigationPage: UINavigationController {
    
    public var animator: Animator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension NavigationPage: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .none {
            return nil
        }
        
        animator?.isPresenting = operation == .push
        return animator
    }
}
