//
//  UIViewExntesions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

class GradientLayer: CAGradientLayer {}

public extension UIView {
    
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
        switch self {
        case let stackView as UIStackView:
            stackView.arrangedSubviews.forEach { view in
                (view as? IDestroyable)?.destroy()
                view.removeFromSuperview()
            }
            
        case let scrollLayout as ScrollLayout:
            scrollLayout.removeAll()
            
        default:
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
    
    /// Set corder radius for specific corners
    func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Set layer border style
    func setBorder(with color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}

extension UIView {
    
    @objc open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
    @objc open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @objc open var borderColor: CGColor? {
        get { return layer.borderColor }
        set { layer.borderColor = newValue }
    }
    
    /// Set box shadow
    @objc open func setShadow(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
        layer.shadowPath = shadowPath.cgPath
    }
}

public extension UIView {
    
    var image: UIImage? { toImage() }
    
    func toImage(_ isOpaque: Bool = false) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func createGradientImage(
        bounds: CGRect,
        colors: [UIColor],
        locations: [Double] = [0, 1],
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        transform: CGAffineTransform? = nil,
        insetBy: (dx: CGFloat, dy: CGFloat)? = nil
    ) -> UIImage? {
        return createGradientLayer(
            bounds: bounds,
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            transform: transform,
            insetBy: insetBy
        ).image
    }
    
    static func createGradientLayer(
        bounds: CGRect,
        colors: [UIColor],
        locations: [Double] = [0, 1],
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        transform: CGAffineTransform? = nil,
        insetBy: (dx: CGFloat, dy: CGFloat)? = nil
    ) -> CAGradientLayer {
        var canvasBounds = bounds
        if let insetBy = insetBy {
            canvasBounds = bounds.insetBy(dx: insetBy.dx*bounds.width, dy: insetBy.dy*bounds.height)
        }
        
        let gradientLayer = GradientLayer()
        gradientLayer.frame = canvasBounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        
        if let startPoint = startPoint {
            gradientLayer.startPoint = startPoint
        }
        
        if let endPoint = endPoint {
            gradientLayer.endPoint = endPoint
        }
        
        if let transform = transform {
            gradientLayer.transform = CATransform3DMakeAffineTransform(transform)
        }
        
        return gradientLayer
    }
    
    @discardableResult
    func setLinearGradient(
        colors: [UIColor],
        locations: [Double] = [0, 1],
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        transform: CGAffineTransform? = nil,
        insetBy: (dx: CGFloat, dy: CGFloat)? = nil
    ) -> CAGradientLayer {
        let gradientLayer = UIView.createGradientLayer(
            bounds: bounds,
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            transform: transform,
            insetBy: insetBy)
        
        // Remove old gradient layer if any
        if let sublayer = layer.sublayers?.first as? GradientLayer {
            sublayer.removeFromSuperlayer()
        }
        layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
    
    @discardableResult
    func autoPin(toTopLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return autoPinEdge(toSuperviewSafeArea: .top, withInset: inset)
        } else {
            return autoPin(toTopLayoutGuideOf: viewController, withInset: inset)
        }
    }
    
    @discardableResult
    func autoPin(toBottomLayoutOf viewController: UIViewController, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return autoPinEdge(toSuperviewSafeArea: .bottom, withInset: inset)
        } else {
            return autoPin(toBottomLayoutGuideOf: viewController, withInset: inset)
        }
    }
}






