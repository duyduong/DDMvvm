//
//  Global.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

/// ViewState for binding from ViewModel and View (Life cycle binding)
public enum PageLifeCycle {
  case willAppear, didAppear, willDisappear, didDisappear
}

public typealias Factory<T> = () -> T

public enum DDConfigurations {
  /*
   Factory for searching top page in our main window

   If your rootViewController is a custom one (such as Drawer...)
   then override this block to make navigation service can find the correct top page
   */
  public static var topPage: Factory<UIViewController?> = {
    func topViewController(
      baseViewController: UIViewController?
    ) -> UIViewController? {
      if let navigationController = baseViewController as? UINavigationController {
        return topViewController(baseViewController: navigationController.visibleViewController)
      } else if let tabBarController = baseViewController as? UITabBarController,
                let selectedViewController = tabBarController.selectedViewController {
        return topViewController(baseViewController: selectedViewController)
      } else if let presentedViewController = baseViewController?.presentedViewController {
        return topViewController(baseViewController: presentedViewController)
      } else if let popupPage = baseViewController as? PopupPage {
        return topViewController(baseViewController: popupPage.children.first)
      }
      return baseViewController
    }

    let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
    return topViewController(baseViewController: rootViewController)
  }
}
