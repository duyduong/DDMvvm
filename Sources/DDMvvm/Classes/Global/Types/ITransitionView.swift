//
//  ITransitionView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit

public protocol ITransitionView where Self: UIViewController {
  /// Keep track of animator delegate for custom transitioning
  var animatorDelegate: AnimatorDelegate? { get }

  /// Transition object to know this view controller transition source
  var transition: Transition? { get }
}

extension ITransitionView {
  public var animatorDelegate: AnimatorDelegate? {
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.AnimatorDelegate) as? AnimatorDelegate
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.AnimatorDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  public var transition: Transition? {
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.Transition) as? Transition
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.Transition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
