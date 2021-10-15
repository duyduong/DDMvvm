//
//  IDestroyable.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 15/10/2021.
//

import RxSwift
import RxCocoa
import UIKit

private enum AssociatedKeys {
  static var disposeBag = "ddmvvm_disposeBag"
}

/// Destroyable type for handling dispose bag and destroy it
public protocol IDestroyable: AnyObject {
  var disposeBag: DisposeBag { get }
  func destroy()
}

public extension IDestroyable {
  var disposeBag: DisposeBag {
    get {
      var disposeBag: DisposeBag
      
      if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
        disposeBag = lookup
      } else {
        disposeBag = DisposeBag()
        objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
      
      return disposeBag
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func destroy() {
    disposeBag = DisposeBag()
  }
}

extension UIViewController: IDestroyable {
  @objc
  open func destroy() {
    disposeBag = DisposeBag()
    animatorDelegate = nil
  }
}

extension UINavigationController {
  open override func destroy() {
    super.destroy()
    viewControllers.forEach { $0.destroy() }
  }
}

extension UITabBarController {
  open override func destroy() {
    super.destroy()
    viewControllers?.forEach { $0.destroy() }
  }
}

extension UIPageViewController {
  open override func destroy() {
    super.destroy()
    viewControllers?.forEach { $0.destroy() }
  }
}
