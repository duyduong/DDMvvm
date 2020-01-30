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
}

public class DecoratorView: AbstractView {
    
    public var decorator: Decorator? = nil {
        didSet { setNeedsLayout() }
    }
    
    private var borderLayer: CAShapeLayer!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
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
}

public extension DecoratorView {
    
    struct Decorator {
        public enum Border {
            case none, solid(width: CGFloat, color: UIColor)
        }
        
        public enum Corner {
            case none, rounded, only(corners: UIRectCorner, radius: CGFloat)
            
            var corners: UIRectCorner {
                switch self {
                case .none, .rounded: return .allCorners
                case .only(let corners, _): return corners
                }
            }
            
            var radius: CGFloat {
                switch self {
                case .none, .rounded: return 0
                case .only(_, let radius): return radius
                }
            }
        }
        
        let border: Border
        let corner: Corner
        
        public init(border: Border, corner: Corner) {
            self.border = border
            self.corner = corner
        }
    }
}
