//
//  UIColorExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension UIColor {
  convenience init(hex: Int) {
    self.init(hex: hex, a: 1.0)
  }

  convenience init(hex: Int, a: CGFloat) {
    self.init(r: (hex >> 16) & 0xFF, g: (hex >> 8) & 0xFF, b: hex & 0xFF, a: a)
  }

  convenience init(r: Int, g: Int, b: Int) {
    self.init(r: r, g: g, b: b, a: 1.0)
  }

  convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
  }

  convenience init?(hex: String) {
    var hex = hex.replacingOccurrences(of: "#", with: "")
    if hex.count == 3 {
      hex += hex
    }
    guard let hex = hex.toHex() else { return nil }
    self.init(hex: hex)
  }

  static func fromHex(_ hex: String) -> UIColor {
    return UIColor(hex: hex) ?? .clear
  }
}
