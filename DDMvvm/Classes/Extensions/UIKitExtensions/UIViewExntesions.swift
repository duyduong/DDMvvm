//
//  UIViewExntesions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIView {
    
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
    public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    // load nib file
    public static func loadFrom<T: UIView>(nibNamed: String, bundle : Bundle? = nil) -> T? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    public func getGesture<G: UIGestureRecognizer>(_ comparison: ((G) -> Bool)? = nil) -> G? {
        return gestureRecognizers?.filter { g in
            if let comparison = comparison {
                return g is G && comparison(g as! G)
            }
            
            return g is G
        }.first as? G
    }
    
    public func getConstraint(byAttribute attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.filter { $0.firstAttribute == attr }.first
    }
    
    // clear all subviews, destroy if needed
    public func clearAll() {
        if let stackView = self as? UIStackView {
            stackView.arrangedSubviews.forEach { view in
                (view as? IDestroyable)?.destroy()
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        } else {
            subviews.forEach { view in
                (view as? IDestroyable)?.destroy()
                view.removeFromSuperview()
            }
        }
    }
    
    // clear all constraints
    public func clearConstraints() {
        constraints.forEach { $0.autoRemove() }
    }
    
    // create border view at specific positions
    @discardableResult
    public func addBorderView(atPosition position: ComponentViewPosition, borderColor: UIColor, borderWidth: CGFloat) -> UIView {
        let borderView = UIView()
        borderView.backgroundColor = borderColor
        addSubview(borderView)
        
        switch position {
        case .top, .bottom:
            borderView.autoSetDimension(.height, toSize: borderWidth)
            borderView.autoPinEdge(toSuperviewEdge: .leading)
            borderView.autoPinEdge(toSuperviewEdge: .trailing)
            switch position {
            case .top:
                borderView.autoPinEdge(toSuperviewEdge: .top)
            default:
                borderView.autoPinEdge(toSuperviewEdge: .bottom)
            }
        case .left, .right:
            borderView.autoSetDimension(.width, toSize: borderWidth)
            borderView.autoPinEdge(toSuperviewEdge: .top)
            borderView.autoPinEdge(toSuperviewEdge: .bottom)
            switch position {
            case .left:
                borderView.autoPinEdge(toSuperviewEdge: .leading)
            default:
                borderView.autoPinEdge(toSuperviewEdge: .trailing)
            }
        default: ()
        }
        
        return borderView
    }
    
    // set corder radius for specific corners
    public func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // set box shadow
    public func setShadow(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
        layer.shadowPath = shadowPath.cgPath
    }
    
    // set layer border style
    public func setBorder(with color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    // set linear gradient background color
    @discardableResult
    public func setGradientBackground(_ topColor: UIColor, bottomColor: UIColor, topLocation: Double, bottomLocation: Double) -> CAGradientLayer {
        let gl = CAGradientLayer()
        gl.colors = [topColor.cgColor, bottomColor.cgColor]
        gl.locations = [NSNumber(value: topLocation), NSNumber(value: bottomLocation)]
        gl.frame = bounds
        layer.insertSublayer(gl, at: 0)
        
        return gl
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func autoPin(toSafeAreaLayoutGuideOf view: UIView, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0)
        constraint.constant = inset
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func autoPin(toTopLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = topAnchor.constraint(equalToSystemSpacingBelow: viewController.view.safeAreaLayoutGuide.topAnchor, multiplier: 0)
            constraint.constant = inset
            constraint.isActive = true
            return constraint
        } else {
            return autoPin(toTopLayoutGuideOf: viewController, withInset: inset)
        }
    }
    
    @discardableResult
    public func autoPin(toBottomLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = bottomAnchor.constraint(equalToSystemSpacingBelow: viewController.view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0)
            constraint.constant = inset
            constraint.isActive = true
            return constraint
        } else {
            return autoPin(toTopLayoutGuideOf: viewController, withInset: inset)
        }
    }
    
}






