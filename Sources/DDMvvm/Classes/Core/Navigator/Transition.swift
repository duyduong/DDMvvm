//
//  Transition.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

public struct Transition {
  public enum TransitionType {
    case auto
    case push
    case modal
    case popup
    case popover
  }
  
  public let type: TransitionType
  public let animator: Animator?
  public let animated: Bool
  
  public init(type: TransitionType = .auto, animator: Animator? = nil, animated: Bool = true) {
    self.type = type
    self.animator = animator
    self.animated = animated
  }
}

public extension Transition {
  static let `default` = Transition()
}

public struct FinishTransition {
  public enum DimissType {
    case auto
    case pop
    case popToRoot
    case popToIndex(Int)
    case popToPage(UIViewController)
    case dismiss
  }

  public let type: DimissType
  public let animated: Bool
  
  public init(type: DimissType = .auto, animated: Bool = true) {
    self.type = type
    self.animated = animated
  }
}

