//
//  TableCell.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import RxSwift
import UIKit

open class TableCell<CellData>: UITableViewCell, CellConfigurable, ICell, IDestroyable {
  open class var identifier: String {
    String(describing: self)
  }

  open var data: CellData? {
    didSet { cellDataChanged() }
  }

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  deinit { destroy() }

  private func setup() {
    backgroundColor = .clear
    separatorInset = .zero
    layoutMargins = .zero
    preservesSuperviewLayoutMargins = false

    initialize()
  }

  func setData(data: Any) {
    self.data = data as? CellData
  }

  override open func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  open func destroy() {
    disposeBag = DisposeBag()
  }

  open func initialize() {}
  open func cellDataChanged() {}
}
