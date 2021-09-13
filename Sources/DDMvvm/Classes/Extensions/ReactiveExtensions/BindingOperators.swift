//
//  BindingOperators.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: - Two way binding shorthand

infix operator <~>: DefaultPrecedence

public func <~> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
  let bindToUIDisposable = relay.bind(to: property)
  let bindToRelay = property.observe(on: MainScheduler.asyncInstance).bind(to: relay)

  return Disposables.create(bindToUIDisposable, bindToRelay)
}

public func <~> <T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
  let bindToUIDisposable = relay.bind(to: property)
  let bindToRelay = property.observe(on: MainScheduler.asyncInstance).bind(to: relay)

  return Disposables.create(bindToUIDisposable, bindToRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

/// Observale
public func ~> <T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
  source.bind(to: binder)
}

public func ~> <T>(source: Observable<T>, binder: Binder<T>) -> Disposable {
  source.bind(to: binder)
}

public func ~> <T>(source: Observable<T>, relay: BehaviorRelay<T>) -> Disposable {
  source.bind(to: relay)
}

public func ~> <T>(source: Observable<T>, relay: BehaviorRelay<T?>) -> Disposable {
  source.bind(to: relay)
}

/// Single
public func ~> <T>(source: Single<T>, relay: BehaviorRelay<T?>) -> Disposable {
  source.subscribe(onSuccess: relay.accept)
}

/// Driver
public func ~> <T>(source: Driver<T>, relay: BehaviorRelay<T?>) -> Disposable {
  source.drive(onNext: relay.accept)
}

public func ~> <T>(source: Driver<T>, binder: Binder<T>) -> Disposable {
  source.drive(onNext: binder.onNext)
}

public func ~> <T>(source: Observable<T>, property: ControlProperty<T>) -> Disposable {
  source.bind(to: property)
}

/// BehaviorRelay
public func ~> <T>(relay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
  relay.bind(to: observer)
}

public func ~> <T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
  relay.bind(to: property)
}

public func ~> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
  relay.bind(to: property)
}

public func ~> <T>(lhs: BehaviorRelay<T>, rhs: BehaviorRelay<T>) -> Disposable {
  lhs.asObservable().bind(to: rhs)
}

/// ControlEvent
public func ~> <T>(event: ControlEvent<T>, relay: BehaviorRelay<T>) -> Disposable {
  event.bind(to: relay)
}

// MARK: - Add to dispose bag shorthand

precedencegroup DisposablePrecedence {
  lowerThan: DefaultPrecedence
}

infix operator =>: DisposablePrecedence

public func => (disposable: Disposable?, bag: DisposeBag?) {
  guard let disposable = disposable, let bag = bag else {
    return
  }
  disposable.disposed(by: bag)
}
