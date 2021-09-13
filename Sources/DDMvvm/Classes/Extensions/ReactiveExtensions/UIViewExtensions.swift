//
//  UIViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIView {
  var tintColor: Binder<UIColor?> {
    Binder(base) { $0.tintColor = $1 }
  }

  var borderColor: Binder<UIColor?> {
    Binder(base) { $0.layer.borderColor = $1?.cgColor }
  }

  var borderWidth: Binder<CGFloat> {
    Binder(base) { $0.layer.borderWidth = $1 }
  }

  var cornerRadius: Binder<CGFloat> {
    Binder(base) { $0.cornerRadius = $1 }
  }
}
