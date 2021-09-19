//
//  Router.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

public protocol RouterType {
  var rootViewController: UIViewController? { get }
  init(rootViewController: UIViewController?)

  /// Navigate to a specific route
  /// - Parameters:
  ///   - route: `Route`
  ///   - transition: Navigation transition
  ///   - animator: Custom animator transitioning
  ///   - completion: Block called after completed navigate
  func route<Route: RouteType>(
    to route: Route,
    transition: Transition,
    completion: (() -> Void)?
  )

  /// Dismiss with a specific transition
  /// - Parameters:
  ///   - transition: Specific `DismissType`
  ///   - completion: Block called after completed dismiss
  func dismiss(transition: FinishTransition, completion: (() -> Void)?)

  /// Dimiss top context page (transition is based on context page transtion)
  /// - Parameter completion: Block called after completed dismiss
  func dismiss(completion: (() -> Void)?)
}

/// Default router for common usage
public struct DefaultRouter: RouterType {
  public let rootViewController: UIViewController?

  public init(rootViewController: UIViewController?) {
    self.rootViewController = rootViewController
  }
}

// MARK: - Default router implementation

public extension RouterType {
  /// Navigate to a specific route
  /// - Parameters:
  ///   - route: `Route`
  ///   - transition: Navigation transition
  ///   - animator: Custom animator transitioning
  ///   - completion: Block called after completed navigate
  func route<Route: RouteType>(
    to route: Route,
    transition: Transition = .default,
    completion: (() -> Void)? = nil
  ) {
    guard let destinationPage = route.makePage(),
          let context = rootViewController ?? DDConfigurations.topPage()
    else { return }
    
    var animatorDelegate: AnimatorDelegate?
    if let animator = transition.animator {
      animatorDelegate = AnimatorDelegate(withAnimator: animator)
    }

    // Inject transition and animator delegate
    destinationPage.transition = transition
    
    // Keep this for backward animation
    // As `transitioningDelegate` will be deinit
    destinationPage.animatorDelegate = animatorDelegate
    
    // Let the animation works
    destinationPage.transitioningDelegate = animatorDelegate

    let animated = transition.animated
    switch transition.type {
    case .auto:
      if let navigationController = context.navigationController {
        navigationController.pushViewController(
          destinationPage,
          animated: transition.animated,
          completions: completion
        )
      } else {
        context.present(destinationPage, animated: transition.animated, completion: completion)
      }

    case .push:
      context.navigationController?.pushViewController(
        destinationPage,
        animated: animated,
        completions: completion
      )

    case .modal:
      if animatorDelegate != nil {
        destinationPage.modalPresentationStyle = .custom
      }
      context.present(destinationPage, animated: animated, completion: completion)

    case .popup:
      guard destinationPage is IPopupView else { return }
      let popupPage = PopupPage(contentPage: destinationPage, showCompletion: completion)
      popupPage.modalPresentationStyle = .overFullScreen
      context.present(popupPage, animated: false)
      
    case .popover:
      guard destinationPage is IPopoverView else { return }
      let popoverPage = PopoverPage(contentPage: destinationPage)
      popoverPage.present(from: context, completion: completion)
    }
  }
  
  /// Dismiss with a specific transition
  /// - Parameters:
  ///   - transition: Specific `DismissType`
  ///   - completion: Block called after completed dismiss
  func dismiss(transition: FinishTransition, completion: (() -> Void)? = nil) {
    guard let context = rootViewController ?? DDConfigurations.topPage() else { return }

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
  
  /// Dimiss top context page (transition is based on context page transtion)
  /// - Parameter completion: Block called after completed dismiss
  func dismiss(completion: (() -> Void)? = nil) {
    guard let context = rootViewController ?? DDConfigurations.topPage() else { return }

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
}

// MARK: -

private extension RouterType {
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
