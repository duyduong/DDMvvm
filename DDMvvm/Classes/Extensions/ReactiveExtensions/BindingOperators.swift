//
//  BindingOperators.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Two way binding shorthand

infix operator <~> : DefaultPrecedence

public func <~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

public func <~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

public func ~><T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
    return source.bind(to: binder)
}

public func ~><T>(source: Observable<T>, binder: Binder<T>) -> Disposable {
    return source.bind(to: binder)
}

public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: relay)
}

public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: relay)
}

public func ~><T>(source: Observable<T>, property: ControlProperty<T>) -> Disposable {
    return source.bind(to: property)
}

public func ~><T>(replay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
    return replay.bind(to: observer)
}

public func ~><T>(event: ControlEvent<T>, relay: BehaviorRelay<T>) -> Disposable {
    return event.bind(to: relay)
}

// MARK: - Add to dispose bag shorthand

precedencegroup DisposablePrecedence {
    lowerThan: DefaultPrecedence
}

infix operator =>: DisposablePrecedence

public func =>(disposable: Disposable?, bag: DisposeBag?) {
    if let d = disposable, let b = bag {
        d.disposed(by: b)
    }
}


















