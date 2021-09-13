//
//  UILabelExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UILabel {
  var textColor: Binder<UIColor?> {
    Binder(base) { $0.textColor = $1 }
  }

  var numberOfLines: Binder<Int> {
    Binder(base) { $0.numberOfLines = $1 }
  }
}
