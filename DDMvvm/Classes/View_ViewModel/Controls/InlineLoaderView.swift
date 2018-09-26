//
//  InlineLoaderView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 4/24/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: InlineLoaderView {
    
    var show: Binder<Bool> {
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
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .white
        addSubview(indicatorView)
        indicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        indicatorView.autoPinEdge(toSuperviewEdge: .top)
        
        label.textColor = .lightText
        label.font = Font.system.normal(withSize: 15)
        addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: indicatorView, withOffset: 3)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewEdge: .bottom)
    }
}












