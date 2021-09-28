//
//  DefaultAlert.swift
//  Example
//
//  Created by Dao Duy Duong on 27/09/2021.
//

import DDMvvm
import UIKit

enum DefaultAlert {
  case ok(title: String, message: String)
}

extension DefaultAlert: AlertType {
  var preferredStyle: UIAlertController.Style { .alert }

  var title: String? {
    switch self {
    case let .ok(title, _): return title
    }
  }
  
  var message: String? {
    switch self {
    case let .ok(_, message): return message
    }
  }
  
  var actions: [AlertAction] {
    switch self {
    case .ok: return [AlertAction(title: "OK", style: .cancel)]
    }
  }
}
