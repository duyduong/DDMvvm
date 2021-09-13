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
    destinationPage.animatorDelegate = animatorDelegate

    let animated = transition.animated
    switch transition.type {
    case .auto:
      if let navigationController = context.navigationController {
        navigationController.pushViewController(destinationPage, animated: transition.animated, completions: completion)
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
    guard let context = DDConfigurations.topPage() else { return }

    switch transition.type {
    case .auto:
      let navigationController = context.navigationController
      if navigationController == nil || navigationController?.viewControllers.first == context {
        context.dismiss(animated: transition.animated) {
          (context as? IDestroyable)?.destroy()
          context.navigationController?.destroy()
          context.tabBarController?.destroy()
          completion?()
        }
      } else {
        navigationController?.popViewController(animated: transition.animated) { page in
          (page as? IDestroyable)?.destroy()
          completion?()
        }
      }
      
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
    guard let context = DDConfigurations.topPage() else { return }

    // Use transition source object to know the current presentation
    if let transition = context.transition {
      switch transition.type {
      case .auto:
        let navigationController = context.navigationController
        if navigationController == nil || navigationController?.viewControllers.first == context {
          context.dismiss(animated: transition.animated) {
            (context as? IDestroyable)?.destroy()
            context.navigationController?.destroy()
            context.tabBarController?.destroy()
            completion?()
          }
        } else {
          navigationController?.popViewController(animated: transition.animated, completions: { page in
            (page as? IDestroyable)?.destroy()
            completion?()
          })
        }
        
      case .push:
        context.navigationController?.popViewController(animated: transition.animated, completions: { page in
          (page as? IDestroyable)?.destroy()
          completion?()
        })
        
      case .modal:
        context.dismiss(animated: transition.animated) {
          (context as? IDestroyable)?.destroy()
          context.navigationController?.destroy()
          context.tabBarController?.destroy()
          completion?()
        }

      case .popup:
        let popupPage = context.parent?.parent as? PopupPage ?? context.parent as? PopupPage ?? context as? PopupPage
        popupPage?.dismiss(animated: false, completion: {
          popupPage?.destroy()
          completion?()
        })

      case .popover:
        context.dismiss(animated: true) {
          (context as? IDestroyable)?.destroy()
          completion?()
        }
      }
    }
  }
}

/// Default router for common usage
public struct DefaultRouter: RouterType {
  public var rootViewController: UIViewController?

  public init(rootViewController: UIViewController?) {
    self.rootViewController = rootViewController
  }
}
