//
//  InlineLoaderView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: LocalHud {
    
    public var show: Binder<Bool> {
        return Binder(base) { view, value in
            if value {
                view.show()
            } else {
                view.hide()
            }
        }
    }
}

open class LocalHud: UIView {
    
    fileprivate let label = UILabel()
    fileprivate let indicatorView = UIActivityIndicatorView(style: .white)
    
    public init(addedToView view: UIView) {
        super.init(frame: .zero)
        
        view.addSubview(self)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Subclasses override this method to style and re-layout components
    open func setupView() {
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .black
        addSubview(indicatorView)
        indicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        indicatorView.autoPinEdge(toSuperviewEdge: .top)
        
        label.textColor = .lightGray
        label.font = Font.system.normal(withSize: 15)
        label.text = "LOADING"
        addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: indicatorView, withOffset: 3)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewEdge: .bottom)
        
        // layout self
        autoCenterInSuperview()
    }
    
    /// Subclasses override this method to setup a custom show animation if needed
    open func show() {
        isHidden = false
        indicatorView.startAnimating()
    }
    
    /// Subclasses override this method to setup a custom hide animation if needed
    open func hide() {
        isHidden = true
        indicatorView.stopAnimating()
    }
}












