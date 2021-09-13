//
//  UIViewExntesions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension UIView {
  /// Load Xib from name
  static func loadFrom<T: UIView>(nibNamed: String, bundle: Bundle? = nil) -> T? {
    let nib = UINib(nibName: nibNamed, bundle: bundle)
    return nib.instantiate(withOwner: nil, options: nil)[0] as? T
  }

  /// Clear all subviews, destroy if needed
  func clearAll() -> Self {
    switch self {
    case let stackView as UIStackView:
      stackView.arrangedSubviews.forEach { view in
        (view as? IDestroyable)?.destroy()
        view.removeFromSuperview()
      }

    default:
      subviews.forEach { view in
        (view as? IDestroyable)?.destroy()
        view.removeFromSuperview()
      }
    }
    return self
  }

  /// Set corder radius for specific corners
  func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }

  /// Set layer border style
  func setBorder(with color: UIColor, width: CGFloat) {
    layer.borderColor = color.cgColor
    layer.borderWidth = width
  }
}

extension UIView {
  @objc
  open var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = true
      clipsToBounds = true
    }
  }

  @objc
  open var borderWidth: CGFloat {
    get { return layer.borderWidth }
    set { layer.borderWidth = newValue }
  }

  @objc
  open var borderColor: CGColor? {
    get { return layer.borderColor }
    set { layer.borderColor = newValue }
  }

  /// Set box shadow
  @objc
  open func setShadow(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat) {
    let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowOpacity = opacity
    layer.shadowRadius = blur
    layer.shadowPath = shadowPath.cgPath
  }
}

public extension UIView {
  var image: UIImage? { toImage() }

  func toImage(_ isOpaque: Bool = false) -> UIImage? {
    defer { UIGraphicsEndImageContext() }

    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

public extension UIView {
  static func gradientImage(gradient: Gradient) -> UIImage? {
    gradientLayer(gradient: gradient).image
  }

  static func gradientLayer(gradient: Gradient) -> CAGradientLayer {
    GradientLayer(gradent: gradient)
  }

  @discardableResult
  func setLinearGradient(gradient: Gradient) -> CAGradientLayer {
    if let sublayer = layer.sublayers?.first as? GradientLayer {
      sublayer.set(gradient: gradient)
      return sublayer
    } else {
      let gradientLayer = GradientLayer(gradent: gradient)
      layer.insertSublayer(gradientLayer, at: 0)
      return gradientLayer
    }
  }
}
