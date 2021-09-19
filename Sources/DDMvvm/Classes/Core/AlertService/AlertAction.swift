//
//  AlertAction.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 19/09/2021.
//

import UIKit

public struct AlertAction {
  public enum Style {
    case `default`, cancel, destructive
  }
  public let title: String
  public let style: Style
  public let isPreferred: Bool
  public let handler: (() -> Void)?
  
  public init(
    title: String,
    style: Style = .default,
    isPreferred: Bool = false,
    handler: (() -> Void)? = nil
  ) {
    self.title = title
    self.style = style
    self.isPreferred = isPreferred
    self.handler = handler
  }
}

extension AlertAction {
  var alertStyle: UIAlertAction.Style {
    switch style {
    case .default: return .default
    case .cancel: return .cancel
    case .destructive: return .destructive
    }
  }
}
