//
//  UIBarButtonItemExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIBarButtonItem {
    
    var image: Binder<UIImage?> {
        return Binder(self.base) { $0.image = $1 }
    }
}










