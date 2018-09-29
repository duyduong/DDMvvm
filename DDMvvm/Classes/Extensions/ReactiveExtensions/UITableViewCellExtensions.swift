//
//  UITableViewCellExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableViewCell {
    
    public var accessoryType: Binder<UITableViewCell.AccessoryType> {
        return Binder(self.base) { $0.accessoryType = $1 }
    }
    
    public var selectionStyle: Binder<UITableViewCell.SelectionStyle> {
        return Binder(self.base) { $0.selectionStyle = $1 }
    }
}







