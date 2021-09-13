//
//  ExampleMenuCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

class ExampleMenuCell: TableCell<Menu> {
  let titleLbl = UILabel()
  let descLbl = UILabel()

  override func initialize() {
    titleLbl.numberOfLines = 0
    titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)

    descLbl.numberOfLines = 0
    descLbl.font = UIFont.preferredFont(forTextStyle: .body)

    let layout = UIStackView(arrangedSubviews: [
      titleLbl, descLbl
    ])
    .setAxis(.vertical)
    contentView.addSubview(layout)
    layout.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.all(5))
    }

    accessoryType = .disclosureIndicator
  }

  override func cellDataChanged() {
    guard let data = data else { return }
    titleLbl.text = data.title
    descLbl.text = data.description
  }
}
