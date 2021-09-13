//
//  UIStackViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit

public extension UIStackView {
  /// Define stack layout axis
  @discardableResult
  func setAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.axis = axis
    return self
  }

  /// Define how stack layout aligns its children
  @discardableResult
  func setAlignment(_ alignment: Alignment) -> Self {
    self.alignment = alignment
    return self
  }

  /// Define how stack layout distributes its children
  @discardableResult
  func setDistribution(_ distribution: Distribution) -> Self {
    self.distribution = distribution
    return self
  }

  /// Spacing between stack items
  @discardableResult
  func setSpacing(_ spacing: CGFloat) -> Self {
    self.spacing = spacing
    return self
  }

  /// Add an array of subviews
  @discardableResult
  func addArrangedSubviews(_ views: [UIView]) -> Self {
    views.forEach { addArrangedSubview($0) }
    return self
  }
}
