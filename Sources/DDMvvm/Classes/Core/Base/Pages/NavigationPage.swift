//
//  NavigationPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxSwift
import UIKit

open class NavigationPage: UINavigationController, UIGestureRecognizerDelegate {
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    return visibleViewController?.preferredStatusBarStyle ?? .default
  }

  override open var prefersStatusBarHidden: Bool {
    return visibleViewController?.prefersStatusBarHidden ?? false
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    interactivePopGestureRecognizer?.delegate = self
  }
}

extension NavigationPage: UINavigationControllerDelegate {
  public func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    var animatorDelegate: AnimatorDelegate?
    switch operation {
    case .push: animatorDelegate = toVC.animatorDelegate
    case .pop: animatorDelegate = fromVC.animatorDelegate
    default: animatorDelegate = nil
    }

    animatorDelegate?.animator.isPresenting = operation == .push
    return animatorDelegate?.animator
  }
}
