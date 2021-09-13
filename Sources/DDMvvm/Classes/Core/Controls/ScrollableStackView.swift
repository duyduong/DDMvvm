//
//  ScrollableStackView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import SnapKit
import UIKit

/// Wrap scroll view into a horizontal or vertical stack layout
public final class ScrollableStackView: UIScrollView {
  private let stackView = UIStackView()
  private let containerView = UIView()

  /// List of subviews inside stack layout
  public var arrangedSubviews: [UIView] {
    stackView.arrangedSubviews
  }

  public init(axis: NSLayoutConstraint.Axis = .vertical) {
    stackView.axis = axis
    super.init(frame: .zero)
    setupView()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  private func setupView() {
    addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }

    switch stackView.axis {
    case .horizontal:
      alwaysBounceHorizontal = true
      containerView.snp.makeConstraints {
        $0.height.equalTo(self)
      }

    default:
      alwaysBounceVertical = true
      containerView.snp.makeConstraints {
        $0.width.equalTo(self)
      }
    }

    containerView.addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func updatePaddings(_ paddings: UIEdgeInsets) {
    stackView.snp.updateConstraints {
      $0.edges
        .equalToSuperview()
        .inset(
          NSDirectionalEdgeInsets(
            top: paddings.top,
            leading: paddings.left,
            bottom: paddings.bottom,
            trailing: paddings.right
          )
        )
    }
  }
}

public extension ScrollableStackView {
  @discardableResult
  func setAlignment(_ alignment: UIStackView.Alignment) -> Self {
    stackView.setAlignment(alignment)
    return self
  }

  /// Define how stack layout distributes its children
  @discardableResult
  func setDistribution(_ distribution: UIStackView.Distribution) -> Self {
    stackView.setDistribution(distribution)
    return self
  }

  /// Append a child into stack layout, accept only UIView or StackItem type,
  /// otherwise will be ignore
  @discardableResult
  func addArrangedSubview(_ view: UIView) -> Self {
    stackView.addArrangedSubview(view)
    return self
  }

  /// Append children into stack layout, accept only UIView or StackItem type,
  /// otherwise will be ignore
  @discardableResult
  func addArrangedSubviews(_ views: [UIView]) -> Self {
    stackView.addArrangedSubviews(views)
    return self
  }

  /// Insert a specific child at index
  @discardableResult
  func insertArrangedSubview(_ view: UIView, at index: Int) -> Self {
    stackView.insertArrangedSubview(view, at: index)
    return self
  }

  /// Update paddings around the layout
  @discardableResult
  func setPaddings(_ insets: UIEdgeInsets = .zero) -> Self {
    updatePaddings(insets)
    return self
  }

  /// Spacing between items
  @discardableResult
  func setInteritemSpacing(_ value: CGFloat) -> Self {
    stackView.setSpacing(value)
    return self
  }

  /// Set a custom spacing after a specific view, this method works after `appendChildren`
  @discardableResult
  func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
    stackView.setCustomSpacing(spacing, after: arrangedSubview)
    return self
  }
}
