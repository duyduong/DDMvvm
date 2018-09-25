//
//  UILabelExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    
    public var attributedText: Binder<NSAttributedString> {
        return Binder(self.base) { $0.attributedText = $1 }
    }
    
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { $0.textColor = $1 }
    }
    
    public var numberOfLines: Binder<Int> {
        return Binder(self.base) { $0.numberOfLines = $1 }
    }
    
}







