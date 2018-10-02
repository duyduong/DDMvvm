//
//  NavigationPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

open class NavigationPage: UINavigationController, ITransitionView {
    
    public var animatorDelegate: AnimatorDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension NavigationPage: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animatorDelegate: AnimatorDelegate?
        switch operation {
        case .none: animatorDelegate = nil
        case .push: animatorDelegate = (toVC as? ITransitionView)?.animatorDelegate
        case .pop: animatorDelegate = (fromVC as? ITransitionView)?.animatorDelegate
        }
        
        animatorDelegate?.animator.isPresenting = operation == .push
        return animatorDelegate?.animator
    }
}
