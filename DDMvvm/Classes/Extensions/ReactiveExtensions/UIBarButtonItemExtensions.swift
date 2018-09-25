//
//  UIBarButtonItemExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 4/18/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    
    var image: Binder<UIImage?> {
        return Binder(self.base) { $0.image = $1 }
    }
    
}










