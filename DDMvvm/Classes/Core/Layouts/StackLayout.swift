//
//  StackLayout.swift
//  DDMvvm
//
//  Created by Macintosh HD on 5/6/19.
//

import UIKit

/*
 A wrapper for UIStackView
 
 For example:
 
 ```
 // Basic usage:
 let layout = StackLayout()
    .direction(.vertical)
    .alignItems(.center)
    .children([
        view1,
        view2,
        view3,
        ...
    ])
 
 // Custom space between items:
 let layout = StackLayout()
     .direction(.vertical)
     .alignItems(.center)
     .children([
         view1,
         StackSpaceItem(height: 20),
         view2,
         StackSpaceItem(height: 20),
         view3,
         ...
     ])
 
 // Stack items with attributes:
 let layout = StackLayout()
     .direction(.vertical)
     .alignItems(.center)
     .children([
         StackViewItem(view: view1, attribute: .centerX),
         StackViewItem(view: view2, attribute: .margin(.only(top: 20))),
         view3,
         ...
    ])
 ```
 */
open class StackLayout: UIStackView {
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    /// Subclasses use this for customizations
    open func setupView() {}
}

public extension StackLayout {
    
    /// Define stack layout axis
    @discardableResult
    func direction(_ axis: NSLayoutConstraint.Axis) -> StackLayout {
        self.axis = axis
        return self
    }
    
    /// Define how stack layout aligns its children
    @discardableResult
    func alignItems(_ alignment: UIStackView.Alignment) -> StackLayout {
        self.alignment = alignment
        return self
    }
    
    /// Define how stack layout distributes its children
    @discardableResult
    func justifyContent(_ distribution: UIStackView.Distribution) -> StackLayout {
        self.distribution = distribution
        return self
    }
    
    /// Spacing between stack items
    @discardableResult
    func spacing(_ value: CGFloat) -> StackLayout {
        self.spacing = value
        return self
    }
    
    /// Add children into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func children(_ items: [Any]) -> StackLayout {
        items.forEach { item in
            if let stackItem = item as? StackItem {
                let view = stackItem.build(with: self)
                self.addArrangedSubview(view)
            } else if let view = item as? UIView {
                self.addArrangedSubview(view)
            }
        }
        return self
    }
}

/// Basic protocol for item inside a stack layout
public protocol StackItem {
    func build(with layout: StackLayout) -> UIView
}

/*
 Stack view item wrapper
 
 Basically wrap a view into a parent view with custom constraints definition
 For example:
 
 ```
 // Center in stack
 StackViewItem(view: logoView) { view in
     view.autoAlignAxis(toSuperviewAxis: .vertical)
     view.autoPinEdge(toSuperviewEdge: .top)
     view.autoPinEdge(toSuperviewEdge: .bottom)
 }
 
 // Using attribute
 StackViewItem(view: logoView, attribute: .centerX)
 ```
 */
public struct StackViewItem: StackItem {
    
    public enum Attribute {
        case margin(insets: UIEdgeInsets)
        case centerX
        case centerY
    }
    
    private let wrapperView = UIView()
    
    private let originalView: UIView
    private let constraintsDefinition: ((UIView) -> ())

    /// Constructor that takes a custom constraints definition
    public init(view: UIView, constraintsDefinition: @escaping ((UIView) -> ())) {
        self.originalView = view
        self.constraintsDefinition = constraintsDefinition
    }
    
    /// Constructor with custom attribute
    public init(view: UIView, attribute: Attribute) {
        self.init(view: view) { (view) in
            switch attribute {
            case .centerX:
                view.autoAlignAxis(toSuperviewAxis: .vertical)
                view.autoPinEdge(toSuperviewEdge: .top)
                view.autoPinEdge(toSuperviewEdge: .bottom)
                
            case .centerY:
                view.autoAlignAxis(toSuperviewAxis: .horizontal)
                view.autoPinEdge(toSuperviewEdge: .leading)
                view.autoPinEdge(toSuperviewEdge: .trailing)
                
            case .margin(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets)
            }
        }
    }
    
    public func build(with layout: StackLayout) -> UIView {
        let wrapperView = UIView()
        wrapperView.addSubview(originalView)
        constraintsDefinition(originalView)
        
        return wrapperView
    }
}

/// Custom spacing between stack items
public struct StackSpaceItem: StackItem {
    
    private let width: CGFloat
    private let height: CGFloat
    
    /// Constructor with both width and height the same size
    public init(size: CGFloat) {
        width = size
        height = size
    }
    
    /// Constructor with width only, mostly use in horizontal stack layout
    public init(width: CGFloat) {
        self.width = width
        self.height = 0
    }
    
    /// Construtor with height only, mostly use in vertical stack layout
    public init(height: CGFloat) {
        self.width = 0
        self.height = height
    }
    
    public func build(with layout: StackLayout) -> UIView {
        let view = UIView()
        view.autoSetDimensions(to: CGSize(width: width, height: height))
        
        return view
    }
}
