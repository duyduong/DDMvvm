//
//  UISwitchExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISwitch {
    
    public var onTintColor: Binder<UIColor> {
        return Binder(self.base) { $0.onTintColor = $1 }
    }
}





