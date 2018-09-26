//
//  Animator.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    public var isPresenting = false
    public var operation: UINavigationController.Operation?
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
}
