//
//  OptionalExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension Optional where Wrapped == String {
    
    public var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
}
