//
//  UISwitchExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISwitch {
    
    public var onTintColor: Binder<UIColor> {
        return Binder(self.base) { $0.onTintColor = $1 }
    }
    
}





