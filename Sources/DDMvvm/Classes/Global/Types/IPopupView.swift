//
//  IPopupView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit

public enum PopupLayout {
  /// Indicate a center poup with horizontal insets
  case center(width: PopupDimension, height: PopupDimension)

  /// Indicate a popup appears on top
  case top(height: PopupDimension)

  /// Indicate a popup appears on bottom
  case bottom(height: PopupDimension)

  /// Indicate a fullscreen popup
  case fullscreen
}

public enum PopupDimension {
  /// Pin edge in pair to superview with insets
  case pinEdge(insets: CGFloat)

  /// Dynamic demension
  case dynamic

  /// Fixed dimension
  case fixed(CGFloat)

  /// Ratio dimension (compared to its superview)
  case ratio(CGFloat)
}

public protocol IPopupView where Self: UIViewController {
  
  /// Layout type for this popup
  var layout: PopupLayout { get }
  
  /// Overlay color
  var overlayColor: UIColor { get }
  
  /// Whether dismiss this popup when tapping on overlay
  var shouldDismissOnTapOutside: Bool { get }
  
  /// Layout this popup (This method called when this popup view is added to its superview
  func makeConstraints()

  /// Show animation
  func show(overlayView: UIView)

  /// Hide animation
  /// - Parameters:
  ///   - overlayView: Overlay view
  ///   - completion: Completion to tell the sender
  func hide(overlayView: UIView, completion: @escaping (() -> Void))
}

public extension IPopupView {
  var overlayColor: UIColor { UIColor.black.withAlphaComponent(0.5) }
  
  var shouldDismissOnTapOutside: Bool { true }
  
  // swiftlint:disable cyclomatic_complexity function_body_length
  func makeConstraints() {
    switch layout {
    case .fullscreen:
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }

    case let .center(width, height):
      switch width {
      case let .fixed(size):
        view.snp.makeConstraints {
          $0.width.equalTo(size)
        }

      case let .ratio(ratio):
        view.snp.makeConstraints {
          $0.width.equalTo(view.superview!.snp.width).multipliedBy(ratio)
        }

      case let .pinEdge(insets):
        view.snp.makeConstraints {
          $0.leading.trailing.equalToSuperview().inset(insets)
        }

      case .dynamic:
        break
      }

      switch height {
      case let .fixed(size):
        view.snp.makeConstraints {
          $0.height.equalTo(size)
        }

      case let .ratio(ratio):
        view.snp.makeConstraints {
          $0.height.equalTo(view.superview!.snp.height).multipliedBy(ratio)
        }

      case let .pinEdge(insets):
        view.snp.makeConstraints {
          $0.top.bottom.equalToSuperview().inset(insets)
        }

      case .dynamic:
        break
      }
      view.snp.makeConstraints {
        $0.center.equalToSuperview()
      }

    case let .top(height):
      switch height {
      case let .fixed(size):
        view.snp.makeConstraints {
          $0.height.equalTo(size)
        }

      case let .ratio(ratio):
        view.snp.makeConstraints {
          $0.height.equalTo(view.superview!.snp.height).multipliedBy(ratio)
        }

      case .pinEdge:
        break

      case .dynamic:
        break
      }
      view.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
      }

    case let .bottom(height):
      switch height {
      case let .fixed(size):
        view.snp.makeConstraints {
          $0.height.equalTo(size)
        }

      case let .ratio(ratio):
        view.snp.makeConstraints {
          $0.height.equalTo(view.superview!.snp.height).multipliedBy(ratio)
        }

      case .pinEdge:
        break

      case .dynamic:
        break
      }
      view.snp.makeConstraints {
        $0.bottom.leading.trailing.equalToSuperview()
      }
    }
  }

  // swiftlint:enable cyclomatic_complexity function_body_length

  func show(overlayView: UIView) {
    overlayView.alpha = 0
    view.isHidden = false

    switch layout {
    case .center:
      view.transform = CGAffineTransform(scaleX: 0, y: 0)
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.4,
        options: .curveEaseIn,
        animations: { [weak self] in
          overlayView.alpha = 1
          self?.view.transform = .identity
        }
      )

    case .top:
      view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
      UIView.animate(withDuration: 0.25, animations: { [weak self] in
        overlayView.alpha = 1
        self?.view.transform = .identity
      })

    case .bottom:
      view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
      UIView.animate(withDuration: 0.25, animations: { [weak self] in
        overlayView.alpha = 1
        self?.view.transform = .identity
      })

    case .fullscreen:
      view.alpha = 0
      UIView.animate(withDuration: 0.25, animations: { [weak self] in
        overlayView.alpha = 1
        self?.view.alpha = 1
      })
    }
  }

  func hide(overlayView: UIView, completion: @escaping (() -> Void)) {
    UIView.animate(
      withDuration: 0.25,
      animations: { [weak self] in
        overlayView.alpha = 0
        self?.view.alpha = 0
      },
      completion: { _ in completion() }
    )
  }
}
