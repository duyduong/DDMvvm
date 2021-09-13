//
//  UISwitchExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UISwitch {
  var onTintColor: Binder<UIColor?> {
    Binder(base) { $0.onTintColor = $1 }
  }
}
