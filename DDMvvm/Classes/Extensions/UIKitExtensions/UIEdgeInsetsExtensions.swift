//
//  UIEdgeInsetsExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    static func builder() -> UIEdgeInsetsBuilder {
        return UIEdgeInsetsBuilder()
    }
    
    static func equally(_ padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    static func topBottom(_ topBottom: CGFloat, leftRight: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
    
    static func top(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    static func left(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    static func right(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
}

class UIEdgeInsetsBuilder {
    private var top: CGFloat = 0
    private var left: CGFloat = 0
    private var bottom: CGFloat = 0
    private var right: CGFloat = 0
    
    func top(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        top = value
        return self
    }
    
    func left(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        left = value
        return self
    }
    
    func bottom(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        bottom = value
        return self
    }
    
    func right(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        right = value
        return self
    }
    
    func build() -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}








