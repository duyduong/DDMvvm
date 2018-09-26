//
//  DDNavigationPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public class DDNavigationPage: UINavigationController {
    
    public var animator: Animator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension DDNavigationPage: UINavigationControllerDelegate {
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let animator = animator {
            animator.operation = operation
            return animator
        }
        
        return nil
    }
    
}
