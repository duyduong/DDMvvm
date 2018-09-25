//
//  DefaultAnimator.swift
//  WTHeo
//
//  Created by Dao Duy Duong on 9/15/17.
//  Copyright © 2017 Nover, Inc. All rights reserved.
//

import UIKit

class DefaultAnimator: Animator {
    
    let minScale: CGFloat = 0.8
    let maxScale: CGFloat = 1.2
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromPage = transitionContext.viewController(forKey: .from)!
        let toPage = transitionContext.viewController(forKey: .to)!
        let duration = transitionDuration(using: transitionContext)
        
        container.backgroundColor = .white
        container.addSubview(toPage.view)
        container.addSubview(fromPage.view)
        
        if isPresenting {
            toPage.view.transform = CGAffineTransform(scaleX: minScale, y: minScale)
            toPage.view.alpha = 0
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                toPage.view.transform = .identity
                toPage.view.alpha = 1
                
                fromPage.view.transform = CGAffineTransform(scaleX: self.maxScale, y: self.maxScale)
                fromPage.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            container.bringSubviewToFront(toPage.view)
            toPage.view.alpha = 0
            toPage.view.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                toPage.view.transform = .identity
                toPage.view.alpha = 1
                
                fromPage.view.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                fromPage.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
    
}










