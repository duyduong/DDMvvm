//
//  DecoratorView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/30/20.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: DecoratorView {
    
    var decorator: Binder<DecoratorView.Decorator?> {
        return Binder(base) { $0.decorator = $1 }
    }
    
    var shadow: Binder<DecoratorView.Shadow?> {
        return Binder(base) { $0.shadow = $1 }
    }
}

open class DecoratorView: AbstractView {
    
    open var colors: [UIColor] = [] {
        didSet { setNeedsLayout() }
    }
    
    open var locations: [Double] = [0, 1] {
        didSet { setNeedsLayout() }
    }
    
    open var startPoint: CGPoint? {
        didSet { setNeedsLayout() }
    }
    
    open var endPoint: CGPoint? {
        didSet { setNeedsLayout() }
    }
    
    open var gradientTransform: CGAffineTransform? {
        didSet { setNeedsLayout() }
    }
    
    open var insetBy: (dx: CGFloat, dy: CGFloat)? {
        didSet { setNeedsLayout() }
    }
    
    open var decorator: Decorator? {
        didSet { setNeedsLayout() }
    }
    
    open var shadow: Shadow? {
        didSet { setNeedsLayout() }
    }
    
    private var borderLayer: CAShapeLayer!
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
        updateShadow()
        updateGradient()
    }
    
    open func updateBorder() {
        guard let decorator = decorator, bounds != .zero else { return }
        layer.masksToBounds = false
        
        var radius = decorator.corner.radius
        switch decorator.corner {
        case .rounded:
            radius = min(bounds.height, bounds.width)/2
        default: ()
        }

        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: decorator.corner.corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        switch decorator.border {
        case .solid(let width, let color):
            borderLayer?.removeFromSuperlayer()
            borderLayer = CAShapeLayer()
            borderLayer.path = mask.path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = color.cgColor
            borderLayer.lineWidth = width
            borderLayer.frame = bounds
            layer.addSublayer(borderLayer)
        default:
            borderLayer?.removeFromSuperlayer()
        }
    }
    
    open func updateShadow() {
        guard let shadow = shadow else { return }
        
        cornerRadius = shadow.cornerRadius
        setShadow(
            offset: shadow.offset,
            color: shadow.color,
            opacity: shadow.opacity,
            blur: shadow.blur
        )
    }
    
    open func updateGradient() {
        guard colors.count > 0 else { return }
        var colors = self.colors
        if colors.count == 1 {
            colors.append(colors[0])
        }
        
        setLinearGradient(
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            transform: gradientTransform,
            insetBy: insetBy
        )
    }
}

public extension DecoratorView {
    
    struct Decorator {
        public enum Border {
            case none, solid(width: CGFloat, color: UIColor)
        }
        
        public enum Corner {
            case none, rounded, only(corners: UIRectCorner, radius: CGFloat)
            
            public var corners: UIRectCorner {
                switch self {
                case .none, .rounded: return .allCorners
                case .only(let corners, _): return corners
                }
            }
            
            public var radius: CGFloat {
                switch self {
                case .none, .rounded: return 0
                case .only(_, let radius): return radius
                }
            }
        }
        
        public let border: Border
        public let corner: Corner
        
        public init(border: Border, corner: Corner) {
            self.border = border
            self.corner = corner
        }
    }
    
    struct Shadow {
        public let offset: CGSize
        public let color: UIColor
        public let opacity: Float
        public let blur: CGFloat
        public let cornerRadius: CGFloat
        
        public init(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat, cornerRadius: CGFloat) {
            self.offset = offset
            self.color = color
            self.opacity = opacity
            self.blur = blur
            self.cornerRadius = cornerRadius
        }
    }
}
