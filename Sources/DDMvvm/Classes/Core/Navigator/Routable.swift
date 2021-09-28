//
//  Routable.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 25/09/2021.
//

import UIKit

public protocol Routable {
  associatedtype Route: RouteType

  /// Route to a specific route without completion
  /// - Parameter route: Destination route
  func route(to route: Route)

  /// Route to a specific route with default transition
  /// - Parameters:
  ///   - route: Destination route
  ///   - completion: Completion block
  func route(to route: Route, completion: (() -> Void)?)

  /// Route to a route with specific transition
  /// - Parameters:
  ///   - route: Destination route
  ///   - transition: Details transition
  ///   - completion: Completion block
  func route(
    to route: Route,
    transition: Transition,
    completion: (() -> Void)?
  )
}

// MARK: - Default implementation on UIViewController

public extension Routable where Self: UIViewController {
  func route(to route: Route) {
    self.route(to: route, transition: .default, completion: nil)
  }

  func route(to route: Route, completion: (() -> Void)?) {
    self.route(to: route, transition: .default, completion: completion)
  }

  func route(
    to route: Route,
    transition: Transition,
    completion: (() -> Void)?
  ) {
    let context = self
    guard let destinationPage = route.makePage() else { return }
    
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
}
