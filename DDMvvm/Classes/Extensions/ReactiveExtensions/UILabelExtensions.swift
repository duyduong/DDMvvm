//
//  UILabelExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UILabel {
    
    var textColor: Binder<UIColor?> {
        return Binder(self.base) { $0.textColor = $1 }
    }
    
    var numberOfLines: Binder<Int> {
        return Binder(self.base) { $0.numberOfLines = $1 }
    }
}







