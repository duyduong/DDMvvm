//
//  OptionalExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension Optional where Wrapped == String {
  var isNilOrEmpty: Bool {
    return self == nil || self!.isEmpty
  }
}
