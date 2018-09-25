//
//  UIViewExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

extension Reactive where Base: UIView {
    
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { $0.backgroundColor = $1 }
    }
    
    var tintColor: Binder<UIColor> {
        return Binder(self.base) { $0.tintColor = $1 }
    }
    
    var borderColor: Binder<UIColor> {
        return Binder(self.base) { $0.layer.borderColor = $1.cgColor }
    }
    
    var borderWidth: Binder<CGFloat> {
        return Binder(self.base) { $0.layer.borderWidth = $1 }
    }
    
    var tapGesture: ControlEvent<UITapGestureRecognizer> {
        var tap: UITapGestureRecognizer! = base.getGesture()
        if tap == nil {
            tap = UITapGestureRecognizer()
            base.addGestureRecognizer(tap)
        }
        
        return tap.rx.event
    }
    
    var panGesture: ControlEvent<UIPanGestureRecognizer> {
        var pan: UIPanGestureRecognizer! = base.getGesture()
        if pan == nil {
            pan = UIPanGestureRecognizer()
            base.addGestureRecognizer(pan)
        }
        
        return pan.rx.event
    }
    
    var pinchGesture: ControlEvent<UIPinchGestureRecognizer> {
        var pinch: UIPinchGestureRecognizer! = base.getGesture()
        if pinch == nil {
            pinch = UIPinchGestureRecognizer()
            base.addGestureRecognizer(pinch)
        }
        
        return pinch.rx.event
    }
    
    var longPressGesture: ControlEvent<UILongPressGestureRecognizer> {
        var longPress: UILongPressGestureRecognizer! = base.getGesture()
        if longPress == nil {
            longPress = UILongPressGestureRecognizer()
            base.addGestureRecognizer(longPress)
        }
        
        return longPress.rx.event
    }
    
}

extension Reactive where Base: UIGestureRecognizer {
    
    var isEnabled: Binder<Bool> {
        return Binder(self.base) { $0.isEnabled = $1 }
    }
    
}

extension UIGestureRecognizer {
    
    // Bind action with input transformation
    func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (UIGestureRecognizer) -> (Input))   {
        // This effectively disposes of any existing subscriptions.
        unbindAction()
        
        // For each tap event, use the inputTransform closure to provide an Input value to the action
        rx.event
            .map { _ in inputTransform(self) }
            .bind(to: action.inputs)
            .disposed(by: actionDisposeBag)
        
        // Bind the enabled state of the control to the enabled state of the action
        action
            .enabled
            .bind(to: rx.isEnabled)
            .disposed(by: actionDisposeBag)
    }
    
    // Bind action with static input
    func bind<Input, Output>(to action: Action<Input, Output>, input: Input)   {
        bind(to: action) { _ in input }
    }
    
    /// Unbinds any existing action, disposing of all subscriptions.
    func unbindAction() {
        resetActionDisposeBag()
    }
    
}











