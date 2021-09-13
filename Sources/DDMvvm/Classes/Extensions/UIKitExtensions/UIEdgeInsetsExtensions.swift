//
//  UIEdgeInsetsExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension UIEdgeInsets {
  static func all(_ padding: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
  }

  static func symmetric(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }

  static func only(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
}
