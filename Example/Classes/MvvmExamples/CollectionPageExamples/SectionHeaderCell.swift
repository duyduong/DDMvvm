//
//  SectionHeaderCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SectionHeaderCell {
  var addSectionObservable: Observable<SectionList> {
    base.addBtn.rx.tap.map { [base] in base.data! }
  }
}

class SectionHeaderCell: CollectionCell<SectionList> {
  private let titleLbl = UILabel()
  fileprivate let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  override func initialize() {
    let toolbar = UIToolbar()
    toolbar.tintColor = .black
    addSubview(toolbar)
    toolbar.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLbl.textColor = .black
    let titleItem = UIBarButtonItem(customView: titleLbl)
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let items = [titleItem, spaceItem, addBtn]
    toolbar.items = items
  }
  
  override func cellDataChanged() {
    guard case let .single(title) = data else { return }
    titleLbl.text = title
  }
}
