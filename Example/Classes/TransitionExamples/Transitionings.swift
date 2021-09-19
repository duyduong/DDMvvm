//
//  Transitionings.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

func delay(_ delay: Double, closure: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
    execute: closure
  )
}

class FlipAnimator: Animator {
  override func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.5
  }

  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toVC = transitionContext.viewController(forKey: .to)!
    let fromVC = transitionContext.viewController(forKey: .from)!
    let duration = transitionDuration(using: transitionContext)

    containerView.addSubview(toVC.view)
    containerView.addSubview(fromVC.view)

    if isPresenting {
      delay(0) { // don't know why, iOS bug?
        UIView.transition(
          from: fromVC.view,
          to: toVC.view,
          duration: duration,
          options: [.transitionFlipFromRight, .showHideTransitionViews]
        ) { _ in
          transitionContext.completeTransition(true)
        }
      }
    } else {
      UIView.transition(
        from: fromVC.view,
        to: toVC.view,
        duration: duration,
        options: [.transitionFlipFromLeft, .showHideTransitionViews]
      ) { _ in
        transitionContext.completeTransition(true)
      }
    }
  }
}

class ZoomAnimator: Animator {
  override func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 2
  }

  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toVC = transitionContext.viewController(forKey: .to)!
    let fromVC = transitionContext.viewController(forKey: .from)!

    let size = containerView.frame.size

    let zoomView = UIView(frame: CGRect(x: 0, y: 0, width: 2 * size.width, height: size.height))
    containerView.addSubview(zoomView)
    zoomView.addSubview(fromVC.view)
    zoomView.addSubview(toVC.view)

    if isPresenting {
      toVC.view.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)

      UIView.animate(withDuration: 0.8) {
        fromVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        toVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }

      UIView.animate(withDuration: 0.5, delay: 0.7, options: .beginFromCurrentState, animations: {
        zoomView.transform = CGAffineTransform(translationX: -2 * fromVC.view.frame.width, y: 0)
      })

      UIView.animate(withDuration: 0.8, delay: 1.2, options: .beginFromCurrentState, animations: {
        fromVC.view.transform = .identity
        toVC.view.transform = .identity
      }) { _ in
        toVC.view.frame = containerView.bounds
        containerView.addSubview(toVC.view)
        zoomView.removeFromSuperview()
        transitionContext.completeTransition(true)
      }
    } else {
      fromVC.view.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
      zoomView.transform = CGAffineTransform(translationX: -size.width, y: 0)

      UIView.animate(withDuration: 0.8) {
        fromVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        toVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }

      UIView.animate(withDuration: 0.5, delay: 0.7, options: .beginFromCurrentState, animations: {
        zoomView.transform = .identity
      })

      UIView.animate(withDuration: 0.8, delay: 1.2, options: .beginFromCurrentState, animations: {
        fromVC.view.transform = .identity
        toVC.view.transform = .identity
      }) { _ in
        toVC.view.frame = containerView.bounds
        containerView.addSubview(toVC.view)
        zoomView.removeFromSuperview()
        transitionContext.completeTransition(true)
      }
    }
  }
}
