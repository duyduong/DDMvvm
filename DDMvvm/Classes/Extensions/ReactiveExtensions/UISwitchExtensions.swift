//
//  UISwitchExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UISwitch {
    
    var onTintColor: Binder<UIColor> {
        return Binder(base) { $0.onTintColor = $1 }
    }
}





