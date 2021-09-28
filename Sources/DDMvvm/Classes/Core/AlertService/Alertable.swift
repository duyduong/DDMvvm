//
//  Alertable.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 27/09/2021.
//

import UIKit
import RxSwift

private enum AlertStore {
  static var window: UIWindow?
  static var queues: [UIAlertController] = []
}

public protocol Alertable {
  associatedtype Alert: AlertType
  func schedule(alert: Alert, completion: ((Int) -> Void)?)
}

/// Alertable allows to schedule an alert on view controller only
public extension Alertable where Self: UIViewController {
  func schedule(alert: Alert, completion: ((Int) -> Void)?) {
    let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.preferredStyle)
    alert.actions.enumerated().forEach { i, action in
      let alertAction = UIAlertAction(title: action.title, style: action.alertStyle) { [weak self] _ in
        action.handler?()
        completion?(i)

        self?.next()
      }
      alertController.addAction(alertAction)
      if action.isPreferred {
        alertController.preferredAction = alertAction
      }
    }
    AlertStore.queues.append(alertController)
    next()
  }

  func schedule(alert: Alert) -> Single<Int> {
    Single.create { single in
      self.schedule(alert: alert) { single(.success($0)) }
      return Disposables.create()
    }
  }

  private func next() {
    guard !AlertStore.queues.isEmpty else {
      AlertStore.window?.isHidden = true
      AlertStore.window = nil
      return
    }
    let alertController = AlertStore.queues.remove(at: 0)
    let window = AlertStore.window ?? UIWindow(frame: UIScreen.main.bounds)
    AlertStore.window = window
    window.windowLevel = .alert
    window.rootViewController = AlertStore.window?.rootViewController ?? UIViewController()
    window.makeKeyAndVisible()
    window.rootViewController?.present(alertController, animated: true)
  }
}
