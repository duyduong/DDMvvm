//
//  NavigationService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit

public enum PushType {
  case auto(animated: Bool, animator: Animator?)
  case push(animated: Bool, animator: Animator?)
  case modally(presentationStyle: UIModalPresentationStyle, animated: Bool, animator: Animator?)
  case popup
}

public extension PushType {
  static let `default` = PushType.auto(animated: true, animator: nil)
}

public enum PopType {
  case auto(animated: Bool)
  case pop(animated: Bool)
  case popToRoot(animated: Bool)
  case popTo(index: Int, animated: Bool)
  case dismiss(animated: Bool)
  case dismissPopup
}

public protocol INavigationService {
  func push(to page: UIViewController, type: PushType, completion: (() -> Void)?)
  func pop(with type: PopType, completion: (() -> Void)?)
}

extension INavigationService {
  public func push(to page: UIViewController, type: PushType = .default, completion: (() -> Void)? = nil) {
    push(to: page, type: type, completion: completion)
  }
  
  public func pop(with type: PopType = .auto(animated: true), completion: (() -> Void)? = nil) {
    pop(with: type, completion: completion)
  }
}

public class NavigationService: INavigationService {
  private var topPage: UIViewController? {
    return DDConfigurations.topPageFindingBlock.create()
  }

  public init() {}

  // MARK: - Push functions
  
  public func push(to page: UIViewController, type: PushType, completion: (() -> Void)? = nil) {
    guard let topPage = topPage else { return }
    
    let handlePush = { (animated: Bool, animator: Animator?) in
      if let animator = animator {
        // attach animtor to destination page
        page.animatorDelegate = AnimatorDelegate(withAnimator: animator)
      }
      
      topPage.navigationController?.pushViewController(page, animated: animated, completions: completion)
    }
    
    let handleModal = { (presentationStyle: UIModalPresentationStyle, animated: Bool, animator: Animator?) in
      if let animator = animator {
        let delegate = AnimatorDelegate(withAnimator: animator)
        page.animatorDelegate = delegate
        page.transitioningDelegate = delegate
        page.modalPresentationStyle = .custom
      } else {
        page.modalPresentationStyle = presentationStyle
      }
      
      topPage.present(page, animated: animated, completion: completion)
    }
    
    switch type {
    case .auto(let animated, let animator):
      if topPage.navigationController != nil {
        handlePush(animated, animator)
      } else {
        handleModal(.fullScreen, animated, animator)
      }
      
    case .push(let animated, let animator):
      handlePush(animated, animator)
      
    case .modally(let presentationStyle, let animated, let animator):
      handleModal(presentationStyle, animated, animator)
      
    case .popup:
      PopupPage.present(contentPage: page, showCompletion: completion)
    }
  }
  
  // MARK: - Pop functions
  
  public func pop(with type: PopType, completion: (() -> Void)? = nil) {
    guard let topPage = topPage else { return }
    
    let handleDismiss = { (animated: Bool) in
      topPage.dismiss(animated: animated) {
        topPage.destroy()
        topPage.navigationController?.destroy()
        topPage.tabBarController?.destroy()
        
        completion?()
      }
    }
    
    switch type {
    case .auto(let animated):
      if let navPage = topPage.navigationController {
        navPage.popViewController(animated: animated) {
          $0?.destroy()
          completion?()
        }
      } else {
        handleDismiss(animated)
      }
      
    case .pop(let animated):
      topPage.navigationController?.popViewController(animated: animated) {
        $0?.destroy()
        completion?()
      }
      
    case .popToRoot(let animated):
      topPage.navigationController?.popToRootViewController(animated: animated) { pages in
        pages?.forEach { $0.destroy() }
        completion?()
      }
      
    case .popTo(let index, let animated):
      topPage.navigationController?.popToViewController(at: index, animated: animated) { pages in
        pages?.forEach { $0.destroy() }
        completion?()
      }
      
    case .dismiss(let animated):
      handleDismiss(animated)
      
    case .dismissPopup:
      let popupPage = UIApplication.shared.keyWindow?.rootViewController as? PopupPage
      popupPage?.dismiss(animated: false, completion: completion)
    }
  }
}






