//
//  ScrollLayout.swift
//  DDMvvm
//
//  Created by Macintosh HD on 5/6/19.
//

import UIKit

/// Wrap scroll view into a horizontal or vertical stack layout
public class ScrollLayout: UIScrollView {
    
    private let layout = StackLayout()
    private let containerView = UIView()
    
    private var topConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    
    /// Scroll view paddings
    public var paddings: UIEdgeInsets = .zero {
        didSet { updatePaddings() }
    }
    
    public init(axis: NSLayoutConstraint.Axis = .vertical) {
        layout.direction(axis)
        super.init(frame: .zero)
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        switch layout.axis {
        case .horizontal:
            alwaysBounceHorizontal = true
            containerView.autoMatch(.height, to: .height, of: self)
        case .vertical:
            alwaysBounceVertical = true
            containerView.autoMatch(.width, to: .width, of: self)
        }
        
        containerView.addSubview(layout)
        topConstraint = layout.autoPinEdge(toSuperviewEdge: .top)
        leftConstraint = layout.autoPinEdge(toSuperviewEdge: .leading)
        bottomConstraint = layout.autoPinEdge(toSuperviewEdge: .bottom)
        rightConstraint = layout.autoPinEdge(toSuperviewEdge: .trailing)
    }
    
    private func updatePaddings() {
        topConstraint.constant = paddings.top
        leftConstraint.constant = paddings.left
        bottomConstraint.constant = -paddings.bottom
        rightConstraint.constant = -paddings.right
    }
    
    /// Append a child into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    public func appendChild(_ child: Any) {
        layout.children([child])
    }
    
    /// Append children into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    public func appendChildren(_ children: [Any]) {
        layout.children(children)
    }
}
