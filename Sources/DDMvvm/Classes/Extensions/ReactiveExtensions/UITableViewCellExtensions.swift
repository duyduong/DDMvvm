//
//  UITableViewCellExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UITableViewCell {
  var accessoryType: Binder<Base.AccessoryType> {
    Binder(base) { $0.accessoryType = $1 }
  }

  var selectionStyle: Binder<Base.SelectionStyle> {
    Binder(base) { $0.selectionStyle = $1 }
  }
}
