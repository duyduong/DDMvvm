//
//  IDestroyable.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import RxSwift
import UIKit

private struct AssociatedKeys {
  static var DisposeBag = "ddmvvm_disposeBag"
}

public protocol IDestroyable {
  var disposeBag: DisposeBag { get }
  func destroy()
}

// Default dispose bag setup
extension IDestroyable where Self: AnyObject {
  /// A dispose bag to be used exclusively for the instance's rx.action.
  public var disposeBag: DisposeBag {
    get {
      var disposeBag: DisposeBag

      if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
        disposeBag = lookup
      } else {
        disposeBag = DisposeBag()
        objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }

      return disposeBag
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  public func destroy() {
    disposeBag = DisposeBag()
  }
}
