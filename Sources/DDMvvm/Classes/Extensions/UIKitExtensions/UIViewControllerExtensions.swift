//
//  UINavigationControllerExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxSwift
import UIKit

public extension UINavigationController {
  func popViewController(animated: Bool, completions: ((UIViewController?) -> Void)?) {
    if animated {
      CATransaction.begin()
      let page = popViewController(animated: animated)
      CATransaction.setCompletionBlock { completions?(page) }
      CATransaction.commit()
    } else {
      let page = popViewController(animated: animated)
      completions?(page)
    }
  }

  func popToRootViewController(animated: Bool, completions: (([UIViewController]?) -> Void)?) {
    if animated {
      CATransaction.begin()
      let pages = popToRootViewController(animated: animated)
      CATransaction.setCompletionBlock { completions?(pages) }
      CATransaction.commit()
    } else {
      let pages = popToRootViewController(animated: animated)
      completions?(pages)
    }
  }

  func popToViewController(at index: Int, animated: Bool, completions: (([UIViewController]?) -> Void)?) {
    let len = viewControllers.count
    if index >= 0, index < len - 1 {
      if animated {
        CATransaction.begin()
        let pages = popToViewController(viewControllers[index], animated: animated)
        CATransaction.setCompletionBlock { completions?(pages) }
        CATransaction.commit()
      } else {
        let pages = popToViewController(viewControllers[index], animated: animated)
        completions?(pages)
      }
    }
  }

  func popToViewController(_ viewController: UIViewController, animated: Bool, completions: (([UIViewController]?) -> Void)?) {
    if animated {
      CATransaction.begin()
      let pages = popToViewController(viewController, animated: animated)
      CATransaction.setCompletionBlock { completions?(pages) }
      CATransaction.commit()
    } else {
      let pages = popToViewController(viewController, animated: animated)
      completions?(pages)
    }
  }

  func pushViewController(_ viewController: UIViewController, animated: Bool, completions: (() -> Void)?) {
    if animated {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completions)
      pushViewController(viewController, animated: animated)
      CATransaction.commit()
    } else {
      pushViewController(viewController, animated: animated)
      completions?()
    }
  }
}

// MARK: -

public extension UINavigationController {
  func popViewControllerSingle(animated: Bool) -> Single<UIViewController?> {
    Single.create { [weak self] single in
      self?.popViewController(animated: animated) { single(.success($0)) }
      return Disposables.create()
    }
  }

  func popToRootViewControllerSingle(animated: Bool) -> Single<[UIViewController]?> {
    Single.create { [weak self] single in
      self?.popToRootViewController(animated: animated) { single(.success($0)) }
      return Disposables.create()
    }
  }

  func popToViewControllerSingle(at index: Int, animated: Bool) -> Single<[UIViewController]?> {
    Single.create { [weak self] single in
      self?.popToViewController(at: index, animated: animated) { single(.success($0)) }
      return Disposables.create()
    }
  }

  func popToViewControllerSingle(_ viewController: UIViewController, animated: Bool) -> Single<[UIViewController]?> {
    Single.create { [weak self] single in
      self?.popToViewController(viewController, animated: animated) { single(.success($0)) }
      return Disposables.create()
    }
  }

  func pushViewControllerSingle(_ viewController: UIViewController, animated: Bool) -> Single<Void> {
    Single.create { [weak self] single in
      self?.pushViewController(viewController, animated: animated) { single(.success(())) }
      return Disposables.create()
    }
  }
}

// MARK: -

extension UIViewController: ITransitionView {}

extension UINavigationController: IDestroyable {
  @objc
  public func destroy() {
    disposeBag = DisposeBag()
    viewControllers.forEach { ($0 as? IDestroyable)?.destroy() }
  }
}

extension UITabBarController: IDestroyable {
  @objc
  public func destroy() {
    disposeBag = DisposeBag()
    viewControllers?.forEach { ($0 as? IDestroyable)?.destroy() }
  }
}
