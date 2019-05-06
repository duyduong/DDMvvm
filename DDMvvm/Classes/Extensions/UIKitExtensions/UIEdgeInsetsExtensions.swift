//
//  UIEdgeInsetsExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension UIEdgeInsets {
    
    public static func builder() -> UIEdgeInsetsBuilder {
        return UIEdgeInsetsBuilder()
    }
    
    @available(*, deprecated, renamed: "all")
    public static func equally(_ padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    public static func all(_ padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    @available(*, deprecated, renamed: "symmetric")
    public static func topBottom(_ topBottom: CGFloat, leftRight: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
    
    public static func symmetric(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    public static func only(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    @available(*, deprecated, renamed: "only")
    public static func top(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    @available(*, deprecated, renamed: "only")
    public static func left(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    @available(*, deprecated, renamed: "only")
    public static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    @available(*, deprecated, renamed: "only")
    public static func right(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
}

public class UIEdgeInsetsBuilder {
    private var top: CGFloat = 0
    private var left: CGFloat = 0
    private var bottom: CGFloat = 0
    private var right: CGFloat = 0
    
    public func top(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        top = value
        return self
    }
    
    public func left(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        left = value
        return self
    }
    
    public func bottom(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        bottom = value
        return self
    }
    
    public func right(_ value: CGFloat) -> UIEdgeInsetsBuilder {
        right = value
        return self
    }
    
    public func build() -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}








