//
//  DecoratorView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/30/20.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: DecoratorView {
  var gradient: Binder<Gradient?> {
    Binder(base) { $0.gradient = $1 }
  }

  var decorator: Binder<DecoratorView.Decorator?> {
    Binder(base) { $0.decorator = $1 }
  }

  var shadow: Binder<DecoratorView.Shadow?> {
    Binder(base) { $0.shadow = $1 }
  }
}

public class DecoratorView: AbstractView {
  public var gradient: Gradient? {
    didSet { setNeedsLayout() }
  }

  public var decorator: Decorator? {
    didSet { setNeedsLayout() }
  }

  public var shadow: Shadow? {
    didSet { setNeedsLayout() }
  }

  private var borderLayer: CAShapeLayer!

  override open func layoutSubviews() {
    super.layoutSubviews()
    guard bounds != .zero else { return }
    updateDecorator()
    updateShadow()
    updateGradient()
  }

  open func updateDecorator() {
    guard let decorator = decorator else { return }
    layer.masksToBounds = false

    var radius = decorator.corner.radius
    switch decorator.corner {
    case .rounded: radius = min(bounds.height, bounds.width) / 2
    default: break
    }

    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: decorator.corner.corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask

    switch decorator.border {
    case let .solid(width, color):
      borderLayer?.removeFromSuperlayer()
      borderLayer = CAShapeLayer()
      borderLayer.path = mask.path
      borderLayer.fillColor = UIColor.clear.cgColor
      borderLayer.strokeColor = color.cgColor
      borderLayer.lineWidth = width
      borderLayer.frame = bounds
      layer.addSublayer(borderLayer)
    default:
      borderLayer?.removeFromSuperlayer()
    }
  }

  open func updateShadow() {
    guard let shadow = shadow else { return }

    cornerRadius = shadow.cornerRadius
    setShadow(
      offset: shadow.offset,
      color: shadow.color,
      opacity: shadow.opacity,
      blur: shadow.blur
    )
  }

  open func updateGradient() {
    guard let gradient = gradient, gradient.colors.count > 0 else { return }
    setLinearGradient(gradient: gradient)
  }
}

public extension DecoratorView {
  enum Border {
    case none, solid(width: CGFloat, color: UIColor)
  }

  enum Corner {
    case none, rounded, only(corners: UIRectCorner, radius: CGFloat)

    public var corners: UIRectCorner {
      switch self {
      case .none, .rounded: return .allCorners
      case let .only(corners, _): return corners
      }
    }

    public var radius: CGFloat {
      switch self {
      case .none, .rounded: return 0
      case let .only(_, radius): return radius
      }
    }
  }

  struct Decorator {
    public let border: Border
    public let corner: Corner

    public init(border: Border, corner: Corner) {
      self.border = border
      self.corner = corner
    }
  }

  struct Shadow {
    public let offset: CGSize
    public let color: UIColor
    public let opacity: Float
    public let blur: CGFloat
    public let cornerRadius: CGFloat

    public init(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat, cornerRadius: CGFloat) {
      self.offset = offset
      self.color = color
      self.opacity = opacity
      self.blur = blur
      self.cornerRadius = cornerRadius
    }
  }
}
