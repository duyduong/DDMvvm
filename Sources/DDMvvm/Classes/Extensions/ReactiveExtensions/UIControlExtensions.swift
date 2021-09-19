//
//  UIControlExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

public extension UIControl {
  /// Allow a UIControl to create a custom control property
  /// - Parameters:
  ///   - control: This control
  ///   - getter: Getter block
  ///   - setter: Setter block
  /// - Returns: `ControlProperty`
  static func toProperty<T, ControlType: UIControl>(
    control: ControlType,
    getter: @escaping (ControlType) -> T,
    setter: @escaping (ControlType, T) -> Void
  ) -> ControlProperty<T> {
    let values: Observable<T> = Observable.deferred { [weak control] in
      guard let existingSelf = control else { return .empty() }

      return existingSelf.rx.controlEvent([.allEditingEvents, .valueChanged])
        .flatMap { _ in
          control.map { Observable.just(getter($0)) } ?? Observable.empty()
        }
        .startWith(getter(existingSelf))
    }

    return ControlProperty(
      values: values,
      valueSink: Binder(control) { setter($0, $1) }
    )
  }
  
  /// Allow a UIControl to create a custom control property for specific event
  /// - Parameters:
  ///   - control: This control
  ///   - event: Change event
  ///   - getter: Getter block
  ///   - setter: Setter block
  /// - Returns: `ControlProperty`
  static func toProperty<T, ControlType: UIControl>(
    control: ControlType,
    event: UIControl.Event,
    getter: @escaping (ControlType) -> T,
    setter: @escaping (ControlType, T) -> Void
  ) -> ControlProperty<T> {
    let values: Observable<T> = Observable.deferred { [weak control] in
      guard let existingSelf = control else { return .empty() }

      return existingSelf.rx.controlEvent(event)
        .flatMap { _ in
          control.map { Observable.just(getter($0)) } ?? Observable.empty()
        }
        .startWith(getter(existingSelf))
    }

    return ControlProperty(
      values: values,
      valueSink: Binder(control) { setter($0, $1) }
    )
  }
}
