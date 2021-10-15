//
//  Global.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

/// ViewState for binding from ViewModel and View (Life cycle binding)
public enum ViewState {
  case none, willAppear, didAppear, willDisappear, didDisappear
}

/// ApplicationState for anyone who wants to know the application state
public enum ApplicationState {
  case none, resignActive, didEnterBackground, willEnterForeground, didBecomeActive, willTerminate
}

/// Factory type
public struct Factory<T> {
  
  /// Block type for factory creation
  public typealias Instantiation<T> = (() -> T)
  
  private let creationBlock: Instantiation<T>
  
  public init(_ creationBlock: @escaping Instantiation<T>) {
    self.creationBlock = creationBlock
  }
  
  public func create() -> T {
    creationBlock()
  }
}

/*
 Global configurations
 
 For some use cases, we have to setup these configurations to make our application work
 correctly
 */
public struct DDConfigurations {
  
  /*
   Factory for searching top page in our main window
   
   If your rootViewController is a custom one (such as Drawer...)
   then override this block to make navigation service can find the correct top page
   */
  public static var topPageFindingBlock: Factory<UIViewController?> = Factory {
    Self.findTopPage()
  }
}

private extension DDConfigurations {
  static func findTopPage(
    baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
  ) -> UIViewController? {
    if let popupPage = baseViewController as? PopupPage {
      return findTopPage(baseViewController: popupPage.contentPage)
    } else if let navigationController = baseViewController as? UINavigationController {
      return findTopPage(baseViewController: navigationController.visibleViewController)
    } else if let tabBarController = baseViewController as? UITabBarController,
              let selectedViewController = tabBarController.selectedViewController {
      return findTopPage(baseViewController: selectedViewController)
    } else if let pageViewController = baseViewController as? UIPageViewController {
      return findTopPage(baseViewController: pageViewController.viewControllers?.first)
    } else if let presentedViewController = baseViewController?.presentedViewController {
      return findTopPage(baseViewController: presentedViewController)
    }
    return baseViewController
  }
}
