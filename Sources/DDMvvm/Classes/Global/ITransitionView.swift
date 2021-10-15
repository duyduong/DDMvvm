//
//  ITransitionView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 15/10/2021.
//

import RxSwift
import RxCocoa
import UIKit

private enum AssociatedKeys {
  static var animatorDelegate = "ddmvvm_animator_delegate"
}

/// TransitionView type to create custom transitioning between pages
public protocol ITransitionView: UIViewController {
  /**
   Keep track of animator delegate for custom transitioning
   */
  var animatorDelegate: AnimatorDelegate? { get }
}

public extension ITransitionView {
  var animatorDelegate: AnimatorDelegate? {
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.animatorDelegate) as? AnimatorDelegate
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.animatorDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIViewController: ITransitionView {}
