//
//  GradientLayer.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit

public struct Gradient {
  let frame: CGRect
  let colors: [UIColor]
  let locations: [Double]
  let startPoint: CGPoint?
  let endPoint: CGPoint?
  let transform: CGAffineTransform?
  let insetBy: (dx: CGFloat, dy: CGFloat)?

  public init(
    frame: CGRect,
    colors: [UIColor],
    locations: [Double],
    startPoint: CGPoint?,
    endPoint: CGPoint?,
    transform: CGAffineTransform?,
    insetBy: (dx: CGFloat, dy: CGFloat)?
  ) {
    self.frame = frame
    self.colors = colors
    self.locations = locations
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.transform = transform
    self.insetBy = insetBy
  }
}

class GradientLayer: CAGradientLayer {
  convenience init(gradent: Gradient) {
    self.init()
    set(gradient: gradent)
  }

  func set(gradient: Gradient) {
    guard gradient.colors.count > 0 else { return }
    var frame = gradient.frame
    if let insetBy = gradient.insetBy {
      frame = frame.insetBy(
        dx: insetBy.dx * frame.width,
        dy: insetBy.dy * frame.height
      )
    }

    var colors = gradient.colors
    if colors.count == 1 {
      colors.append(colors[0])
    }

    self.frame = frame
    self.colors = colors.map { $0.cgColor }
    locations = gradient.locations.map { NSNumber(value: $0) }

    if let startPoint = gradient.startPoint {
      self.startPoint = startPoint
    }

    if let endPoint = gradient.endPoint {
      self.endPoint = endPoint
    }

    if let transform = gradient.transform {
      self.transform = CATransform3DMakeAffineTransform(transform)
    }
  }
}
