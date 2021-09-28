//
//  Dismissable.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 27/09/2021.
//

import UIKit

// MARK: - Dismissable

public protocol Dismissable {
  /// Dismiss without completion
  func dismiss()

  /// Dismiss with completion
  /// - Parameter completion: Completion block after dismissed
  func dismiss(completion: (() -> Void)?)

  /// Dismiss with a specific transition
  /// - Parameters:
  ///   - transition: Specific `DismissType`
  ///   - completion: Completion block after dismissed
  func dismiss(transition: FinishTransition, completion: (() -> Void)?)
}

public extension Dismissable where Self: UIViewController {
  /// Dismiss without completion
  func dismiss() {
    dismiss(completion: nil)
  }

  /// Dimiss top context page (transition is based on context page transtion)
  /// - Parameter completion: Block called after completed dismiss
  func dismiss(completion: (() -> Void)?) {
    let context = self

    // Use transition source object to know the current presentation
    guard let transition = context.transition ??
            context.navigationController?.transition ??
            context.tabBarController?.transition
    else {
      return dismissAuto(from: context, animated: true, completion: completion)
    }
    switch transition.type {
    case .auto:
      dismissAuto(from: context, animated: transition.animated, completion: completion)
      
    case .push:
      context.navigationController?.popViewController(animated: transition.animated) { page in
        (page as? IDestroyable)?.destroy()
        completion?()
      }
      
    case .modal:
      context.dismiss(animated: transition.animated) {
        (context as? IDestroyable)?.destroy()
        context.navigationController?.destroy()
        context.tabBarController?.destroy()
        completion?()
      }

    case .popup:
      let popupPage = context.parent?.parent as? PopupPage ??
        context.parent as? PopupPage ??
        context as? PopupPage
      popupPage?.dismiss(animated: false) {
        popupPage?.destroy()
        completion?()
      }

    case .popover:
      context.dismiss(animated: true) {
        (context as? IDestroyable)?.destroy()
        completion?()
      }
    }
  }

  /// Dismiss with a specific transition
  /// - Parameters:
  ///   - transition: Specific `DismissType`
  ///   - completion: Block called after completed dismiss
  func dismiss(transition: FinishTransition, completion: (() -> Void)?) {
    let context = self

    switch transition.type {
    case .auto:
      dismissAuto(from: context, animated: transition.animated, completion: completion)
      
    case .pop:
      context.navigationController?.popViewController(animated: transition.animated) { page in
        (page as? IDestroyable)?.destroy()
        completion?()
      }
      
    case .popToRoot:
      context.navigationController?.popToRootViewController(animated: transition.animated) { pages in
        pages?.forEach { ($0 as? IDestroyable)?.destroy() }
        completion?()
      }
      
    case let .popToIndex(index):
      context.navigationController?.popToViewController(at: index, animated: transition.animated) { pages in
        pages?.forEach { ($0 as? IDestroyable)?.destroy() }
        completion?()
      }
      
    case let .popToPage(page):
      context.navigationController?.popToViewController(page, animated: transition.animated) { pages in
        pages?.forEach { ($0 as? IDestroyable)?.destroy() }
        completion?()
      }

    case .dismiss:
      context.dismiss(animated: transition.animated) {
        (context as? IDestroyable)?.destroy()
        context.navigationController?.destroy()
        context.tabBarController?.destroy()
        completion?()
      }
    }
  }
}

private extension Dismissable {
  func dismissAuto(from context: UIViewController, animated: Bool, completion: (() -> Void)?) {
    let navigationController = context.navigationController
    if navigationController == nil || navigationController?.viewControllers.first == context {
      context.dismiss(animated: animated) {
        (context as? IDestroyable)?.destroy()
        context.navigationController?.destroy()
        context.tabBarController?.destroy()
        completion?()
      }
    } else {
      navigationController?.popViewController(animated: animated) { page in
        (page as? IDestroyable)?.destroy()
        completion?()
      }
    }
  }
}

