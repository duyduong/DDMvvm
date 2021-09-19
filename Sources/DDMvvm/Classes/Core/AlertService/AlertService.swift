//
//  AlertService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 19/09/2021.
//

import UIKit
import RxSwift

public protocol IAlertService {
  func schedule(alert: AlertType, preferredStyle: UIAlertController.Style, completion: ((Int) -> Void)?)
}

public extension IAlertService {
  func schedule(alert: AlertType, preferredStyle: UIAlertController.Style) -> Single<Int> {
    Single.create { single in
      self.schedule(alert: alert, preferredStyle: preferredStyle) { single(.success($0)) }
      return Disposables.create()
    }
  }
}

public class AlertService {
  /// Own alert window
  private static var window: UIWindow?
  private static var queues: [UIAlertController] = []
  
  public init() {}
}

extension AlertService: IAlertService {
  public func schedule(alert: AlertType, preferredStyle: UIAlertController.Style, completion: ((Int) -> Void)?) {
    let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: preferredStyle)
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
    Self.queues.append(alertController)
    next()
  }
}

private extension AlertService {
  func next() {
    guard !Self.queues.isEmpty else {
      Self.window?.isHidden = true
      Self.window = nil
      return
    }
    let alertController = Self.queues.remove(at: 0)
    let window = Self.window ?? UIWindow(frame: UIScreen.main.bounds)
    window.windowLevel = .alert
    window.rootViewController = Self.window?.rootViewController ?? UIViewController()
    window.makeKeyAndVisible()
    window.rootViewController?.present(alertController, animated: true)
  }
}
