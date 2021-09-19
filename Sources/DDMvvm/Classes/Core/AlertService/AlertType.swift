//
//  AlertType.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 19/09/2021.
//

import Foundation

public protocol AlertType {
  var title: String? { get }
  var message: String? { get }
  var actions: [AlertAction] { get }
}

public enum DefaultAlert {
  case error(Error)
  case ok(title: String, messge: String)
}

extension DefaultAlert: AlertType {
  public var title: String? {
    switch self {
    case .error: return "Error"
    case let .ok(title, _): return title
    }
  }
  
  public var message: String? {
    switch self {
    case let .error(error): return error.localizedDescription
    case let .ok(_, message): return message
    }
  }
  
  public var actions: [AlertAction] {
    [.init(title: "OK", style: .cancel)]
  }
}
