//
//  UIEdgeInsetsExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension UIEdgeInsets {
  static func all(_ padding: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
  }
  
  static func symmetric(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
    return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
  
  static func only(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
}

@available(iOS 11.0, *)
public extension NSDirectionalEdgeInsets {
  static func all(_ padding: CGFloat) -> NSDirectionalEdgeInsets {
    return NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
  }
  
  static func symmetric(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> NSDirectionalEdgeInsets {
    return NSDirectionalEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
  }
  
  static func only(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> NSDirectionalEdgeInsets {
    return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
  }
}








