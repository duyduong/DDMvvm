//
//  AlertType.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 19/09/2021.
//

import UIKit

public protocol AlertType {
  var preferredStyle: UIAlertController.Style { get }
  var title: String? { get }
  var message: String? { get }
  var actions: [AlertAction] { get }
}
