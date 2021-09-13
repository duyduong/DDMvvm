//
//  View.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import RxSwift
import UIKit

/// Based UIView that support ViewModel
open class View<ViewModel>: UIView, IDestroyable {
  public let viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setup()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(viewModel:)")
  }

  deinit { destroy() }

  func setup() {
    initialize()
    bindViewAndViewModel()
  }

  open func destroy() {
    disposeBag = DisposeBag()
    (viewModel as? IDestroyable)?.destroy()
  }

  open func initialize() {}
  open func bindViewAndViewModel() {}
}
