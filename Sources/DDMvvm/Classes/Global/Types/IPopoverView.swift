//
//  IPopoverView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 13/09/2021.
//

import UIKit

public enum SourceType {
  case barItem(UIBarButtonItem)
  case sourceView(view: UIView, rect: CGRect?)
}

public protocol IPopoverView: AnyObject {
  var sourceType: SourceType { get }
  var backgroundColor: UIColor? { get }
  var locationView: UIView? { get }
  func permittedArrowDirections() -> UIPopoverArrowDirection
}
