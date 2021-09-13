//
//  SimpleListPageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

class SimpleListPageCell: TableCell<String> {
  let titleLbl = UILabel()

  override func initialize() {
    contentView.addSubview(titleLbl)
    titleLbl.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.symmetric(horizontal: 15, vertical: 10))
    }
  }
  
  override func cellDataChanged() {
    guard let title = data else { return }
    titleLbl.text = title
  }
}
