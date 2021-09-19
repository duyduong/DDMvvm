//
//  Contact.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import Foundation

struct Contact: Hashable {
  var id = UUID().uuidString
  let name: String
  let phone: String
}
