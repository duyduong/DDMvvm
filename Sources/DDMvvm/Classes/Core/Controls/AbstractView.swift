//
//  AbstractView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

open class AbstractView: UIView {
  public init() {
    super.init(frame: .zero)
    setupView()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  open func setupView() {}
}

open class AbstractControlView: UIControl {
  public init() {
    super.init(frame: .zero)
    setupView()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  open func setupView() {}
}
