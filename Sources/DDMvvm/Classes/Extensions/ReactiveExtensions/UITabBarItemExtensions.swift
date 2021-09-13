//
//  UITabBarItemExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UITabBarItem {
  var image: Binder<UIImage?> {
    Binder(base) { $0.image = $1 }
  }

  var title: Binder<String?> {
    Binder(base) { $0.title = $1 }
  }

  var badge: Binder<Int> {
    Binder(base) { control, value in
      control.badgeValue = value <= 0 ? nil : value.description
    }
  }
}
