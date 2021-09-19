//
//  MenuModel.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import Foundation

protocol Menu: Hashable, RouteType {
  var title: String { get }
  var description: String { get }
}
