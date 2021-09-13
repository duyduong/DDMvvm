//
//  SimpleCollectionPageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

class SimpleCollectionPageCell: CollectionCell<String> {
  let titleLbl = UILabel()

  override func initialize() {
    cornerRadius = 5
    backgroundColor = .black

    titleLbl.textColor = .white
    titleLbl.numberOfLines = 0
    contentView.addSubview(titleLbl)
    titleLbl.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.all(5))
    }
  }

  override func cellDataChanged() {
    guard let title = data else { return }
    titleLbl.text = title
  }
}
