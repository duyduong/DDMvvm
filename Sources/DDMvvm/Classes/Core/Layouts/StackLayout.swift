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
         StackViewItem(view: view1, attribute: .center(insets: .all(5))),
         StackViewItem(view: view2, attribute: .fill(.only(top: 20))),
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

/// Children builder
public extension StackLayout {
    
    @_functionBuilder
    struct ChildrenBuilder {
        public static func buildBlock(_ components: [UIView]...) -> [UIView] {
            return components.flatMap { $0 }
        }
        
        public static func buildExpression(_ component: UIView) -> [UIView] {
            return [component]
        }
        
        public static func buildExpression(_ components: [UIView]...) -> [UIView] {
            return components.flatMap { $0 }
        }
        
        public static func buildIf(_ components: [UIView]?...) -> [UIView] {
            return components.compactMap { $0 }.flatMap { $0 }
        }
        
        public static func buildEither(first: [UIView]) -> [UIView] {
            return first
        }
        
        public static func buildEither(second: [UIView]) -> [UIView] {
            return second
        }
    }
    
    static func ForIn<S: Sequence>(_ sequence: S, @ChildrenBuilder builder: (S.Element) -> [UIView]) -> [UIView] {
        return sequence.flatMap(builder)
    }
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
    func alignItems(_ alignment: Alignment) -> StackLayout {
        self.alignment = alignment
        return self
    }
    
    /// Define how stack layout distributes its children
    @discardableResult
    func justifyContent(_ distribution: Distribution) -> StackLayout {
        self.distribution = distribution
        return self
    }
    
    /// Spacing between stack items
    @discardableResult
    func spacing(_ value: CGFloat) -> StackLayout {
        spacing = value
        return self
    }
    
    /// Add children into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func children(_ children: [UIView]) -> StackLayout {
        children.forEach { addArrangedSubview($0) }
        children.compactMap { $0 as? StackItem }.forEach {
            $0.layout(with: self)
        }
        return self
    }
    
    /// Add children into stack layout using builder
    @discardableResult
    func childrenBuilder(@ChildrenBuilder _ children: () -> [UIView]) -> StackLayout {
        return self.children(children())
    }
    
    /// Insert a child at specific index, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func child(_ child: UIView, at index: Int) -> StackLayout {
        guard index >= 0 && index < arrangedSubviews.count else { return self }
        
        insertArrangedSubview(child, at: index)
        (child as? StackItem)?.layout(with: self)
        return self
    }
    
    /// Remove a specific child at index
    @discardableResult
    func removeChild(at index: Int) -> StackLayout {
        guard index >= 0 && index < arrangedSubviews.count else { return self }
        
        let child = arrangedSubviews[index]
        removeArrangedSubview(child)
        (child as? IDestroyable)?.destroy()
        child.removeFromSuperview()
        
        return self
    }
}

/// Basic protocol for item inside a stack layout
public protocol StackItem where Self: UIView {
    func layout(with layout: StackLayout)
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
 StackViewItem(view: logoView, attribute: .center(insets: .all(5)))
 ```
 */
public class StackViewItem: UIView, StackItem {
    
    public enum Attribute {
        /// Align left with insets
        case leading(insets: UIEdgeInsets)
        
        /// Align right with insets
        case trailing(insets: UIEdgeInsets)
        
        /// Align top with insets
        case top(insets: UIEdgeInsets)
        
        /// Align bottom with insets
        case bottom(insets: UIEdgeInsets)
        
        /// Center the view
        case center(insets: UIEdgeInsets)
        
        /// Fill the content with insets
        case fill(insets: UIEdgeInsets)
        
        func layout(withView view: UIView) {
            switch self {
            case .leading(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .trailing)
                view.autoPinEdge(toSuperviewEdge: .trailing, withInset: insets.right, relation: .greaterThanOrEqual)
                
            case .trailing(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .leading)
                view.autoPinEdge(toSuperviewEdge: .leading, withInset: insets.left, relation: .greaterThanOrEqual)
                
            case .top(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
                view.autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
                
            case .bottom(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
                view.autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
                
            case .center(let insets):
                view.autoCenterInSuperview()
                view.autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .leading, withInset: insets.left, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .trailing, withInset: insets.right, relation: .greaterThanOrEqual)
                
            case .fill(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets)
            }
        }
    }

    /// Constructor that takes a custom constraints definition
    public init(view: UIView, constraintsDefinition: @escaping ((UIView) -> ())) {
        super.init(frame: .zero)
        addSubview(view)
        constraintsDefinition(view)
    }
    
    /// Constructor with custom attribute
    public init(view: UIView, attribute: Attribute) {
        super.init(frame: .zero)
        
        addSubview(view)
        attribute.layout(withView: view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func layout(with layout: StackLayout) {}
}

/// Custom spacing between stack items
public class StackSpaceItem: UIView, StackItem {
    
    /// Constructor with both width and height the same size
    public init(size: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: .square(size)))
    }
    
    /// Constructor with width only, mostly use in horizontal stack layout
    public init(width: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 0)))
    }
    
    /// Construtor with height only, mostly use in vertical stack layout
    public init(height: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: height)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func layout(with layout: StackLayout) {
        autoSetDimensions(to: CGSize(width: frame.width, height: frame.height))
    }
}

/// Custom ratio spacing between items
public class StackFlexibleItem: UIView, StackItem {
    
    var widthRatio: CGFloat?
    var heightRatio: CGFloat?
    
    /// Constructor with width only, mostly use in horizontal stack layout
    public init(widthRatio: CGFloat) {
        self.widthRatio = widthRatio
        super.init(frame: .zero)
    }
    
    /// Construtor with height only, mostly use in vertical stack layout
    public init(heightRatio: CGFloat) {
        self.heightRatio = heightRatio
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func layout(with layout: StackLayout) {
        if let widthRatio = widthRatio {
            autoMatch(.width, to: .width, of: layout, withMultiplier: widthRatio)
        }
        
        if let heightRatio = heightRatio {
            autoMatch(.height, to: .height, of: layout, withMultiplier: heightRatio)
        }
    }
}
