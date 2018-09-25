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
    
    public var backgroundColor: Binder<UIColor> {
        return Binder(base) { $0.backgroundColor = $1 }
    }
    
    public var tintColor: Binder<UIColor> {
        return Binder(base) { $0.tintColor = $1 }
    }
    
    public var borderColor: Binder<UIColor> {
        return Binder(base) { $0.layer.borderColor = $1.cgColor }
    }
    
    public var borderWidth: Binder<CGFloat> {
        return Binder(base) { $0.layer.borderWidth = $1 }
    }
    
    public var tapGesture: ControlEvent<UITapGestureRecognizer> {
        var tap: UITapGestureRecognizer! = base.getGesture()
        if tap == nil {
            tap = UITapGestureRecognizer()
            base.addGestureRecognizer(tap)
        }
        
        return tap.rx.event
    }
    
    public var panGesture: ControlEvent<UIPanGestureRecognizer> {
        var pan: UIPanGestureRecognizer! = base.getGesture()
        if pan == nil {
            pan = UIPanGestureRecognizer()
            base.addGestureRecognizer(pan)
        }
        
        return pan.rx.event
    }
    
    public var pinchGesture: ControlEvent<UIPinchGestureRecognizer> {
        var pinch: UIPinchGestureRecognizer! = base.getGesture()
        if pinch == nil {
            pinch = UIPinchGestureRecognizer()
            base.addGestureRecognizer(pinch)
        }
        
        return pinch.rx.event
    }
    
    public var longPressGesture: ControlEvent<UILongPressGestureRecognizer> {
        var longPress: UILongPressGestureRecognizer! = base.getGesture()
        if longPress == nil {
            longPress = UILongPressGestureRecognizer()
            base.addGestureRecognizer(longPress)
        }
        
        return longPress.rx.event
    }
}













