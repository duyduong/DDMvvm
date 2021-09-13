//
//  UIKitExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension UIImage {
  /// Create image from mono color
  static func from(color: UIColor) -> UIImage {
    let size = CGSize(width: 1, height: 1)
    return from(color: color, withSize: size)
  }

  /// Create image from mono color with specific size and corner radius
  static func from(color: UIColor, withSize size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
    defer { UIGraphicsEndImageContext() }

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    let path = UIBezierPath(
      roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
      cornerRadius: cornerRadius
    )
    path.addClip()
    color.setFill()
    path.fill()
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
}

public extension UIImage {
  func withColor(_ color: UIColor) -> UIImage? {
    defer { UIGraphicsEndImageContext() }

    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }

    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    color.setFill()
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1, y: -1)
    context.setBlendMode(.normal)
    context.clip(to: rect, mask: cgImage)
    context.fill(rect)

    return UIGraphicsGetImageFromCurrentImageContext()
  }

  func withAlpha(_ value: CGFloat) -> UIImage? {
    defer { UIGraphicsEndImageContext() }

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    draw(at: .zero, blendMode: .normal, alpha: value)
    return UIGraphicsGetImageFromCurrentImageContext()
  }

  func withSize(_ size: CGSize) -> UIImage? {
    defer { UIGraphicsEndImageContext() }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: size)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
