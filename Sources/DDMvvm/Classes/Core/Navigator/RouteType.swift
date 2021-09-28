//
//  RouteType.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

public protocol RouteType {
  func makePage() -> UIViewController?
}

public extension RouteType {
  func makePage() -> UIViewController? { nil }
}
