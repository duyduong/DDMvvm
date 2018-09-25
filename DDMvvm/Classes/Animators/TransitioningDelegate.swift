//
//  BaseTransition.swift
//  WTHeo
//
//  Created by Dao Duy Duong on 8/7/17.
//  Copyright © 2017 Nover, Inc. All rights reserved.
//

import UIKit

public class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let animator: Animator
    
    init(withAnimator animator: Animator) {
        self.animator = animator
        super.init()
    }
    
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    internal func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

open class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    public var isPresenting = false
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
    
}

class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}











