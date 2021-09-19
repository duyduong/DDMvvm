//
//  CollectionCell.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit
import RxSwift

open class CollectionCell<CellData>: UICollectionViewCell, CellConfigurable, ICell, IDestroyable {
  open class var identifier: String {
    String(describing: self)
  }
  
  open var data: CellData? {
    didSet { cellDataChanged() }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  deinit { destroy() }
  
  private func setup() {
    backgroundColor = .clear
    initialize()
  }
  
  /// Internally called when configure cell
  /// - Parameter data: `CellData`
  func setData(data: Any) {
    self.data = data as? CellData
  }
  
  open override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  open func destroy() {
    disposeBag = DisposeBag()
  }
  
  open func initialize() {}
  open func cellDataChanged() {}
}
