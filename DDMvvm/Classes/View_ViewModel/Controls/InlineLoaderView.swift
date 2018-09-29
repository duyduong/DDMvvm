//
//  InlineLoaderView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: InlineLoaderView {
    
    public var show: Binder<Bool> {
        return Binder(self.base) { view, value in
            if value {
                view.isHidden = false
                view.indicatorView.startAnimating()
            } else {
                view.isHidden = true
                view.indicatorView.stopAnimating()
            }
        }
    }
}

public class InlineLoaderView: AbstractControlView {
    
    public var textColor: UIColor {
        get { return label.textColor }
        set { label.textColor = newValue }
    }
    
    public var indicatorColor: UIColor {
        get { return indicatorView.color }
        set { indicatorView.color = newValue }
    }
    
    public var loadingText: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    fileprivate let label = UILabel()
    fileprivate let indicatorView = UIActivityIndicatorView(style: .white)
    
    public override func setupView() {
        let settings = DDConfigurations.inlineLoaderViewSettings
        
        indicatorView.hidesWhenStopped = true
        indicatorView.color = settings.indicatorColor
        addSubview(indicatorView)
        indicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        indicatorView.autoPinEdge(toSuperviewEdge: .top)
        
        label.textColor = settings.textColor
        label.font = settings.font
        label.text = settings.loadingText
        addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: indicatorView, withOffset: 3)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    public static func attach(to view: UIView, position: ComponentViewPosition = .center) -> InlineLoaderView {
        let inlineLoaderView = InlineLoaderView()
        view.addSubview(inlineLoaderView)
        
        switch position {
        case .center:
            inlineLoaderView.autoCenterInSuperview()
            
        case .top(let offset):
            inlineLoaderView.autoAlignAxis(toSuperviewAxis: .vertical)
            inlineLoaderView.autoPinEdge(toSuperviewEdge: .top, withInset: offset)
        
        case .bottom(let offset):
            inlineLoaderView.autoAlignAxis(toSuperviewAxis: .vertical)
            inlineLoaderView.autoPinEdge(toSuperviewEdge: .bottom, withInset: offset)
            
        case .left(let offset):
            inlineLoaderView.autoAlignAxis(toSuperviewAxis: .horizontal)
            inlineLoaderView.autoPinEdge(toSuperviewEdge: .left, withInset: offset)
            
        case .right(let offset):
            inlineLoaderView.autoAlignAxis(toSuperviewAxis: .horizontal)
            inlineLoaderView.autoPinEdge(toSuperviewEdge: .right, withInset: offset)
        }
        
        return inlineLoaderView
    }
}












