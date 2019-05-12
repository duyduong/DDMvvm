//
//  UIViewExntesions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    /// Load Xib from name
    static func loadFrom<T: UIView>(nibNamed: String, bundle : Bundle? = nil) -> T? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    func getGesture<G: UIGestureRecognizer>(_ comparison: ((G) -> Bool)? = nil) -> G? {
        return gestureRecognizers?.filter { g in
            if let comparison = comparison {
                return g is G && comparison(g as! G)
            }
            
            return g is G
        }.first as? G
    }
    
    func getConstraint(byAttribute attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.filter { $0.firstAttribute == attr }.first
    }
    
    /// Clear all subviews, destroy if needed
    func clearAll() {
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
    
    /// Clear all constraints
    func clearConstraints() {
        constraints.forEach { $0.autoRemove() }
    }
    
    /// Create border view at specific positions
    @discardableResult
    func addBorderView(atPosition position: ComponentViewPosition, borderColor: UIColor, borderWidth: CGFloat) -> UIView {
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
    
    /// Set corder radius for specific corners
    func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Set box shadow
    func setShadow(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
        layer.shadowPath = shadowPath.cgPath
    }
    
    /// Set layer border style
    func setBorder(with color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Set linear gradient background color
    @discardableResult
    func setGradientBackground(_ topColor: UIColor, bottomColor: UIColor, topLocation: Double, bottomLocation: Double) -> CAGradientLayer {
        let gl = CAGradientLayer()
        gl.colors = [topColor.cgColor, bottomColor.cgColor]
        gl.locations = [NSNumber(value: topLocation), NSNumber(value: bottomLocation)]
        gl.frame = bounds
        layer.insertSublayer(gl, at: 0)
        
        return gl
    }
    
    @discardableResult
    func autoPin(toTopLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
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
    func autoPin(toBottomLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
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






