//
//  SimpleCollectionPageCells.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

class CollectionTextCell: CollectionCell<SectionListItem> {
  let titleLbl = UILabel()
  let descLbl = UILabel()

  override func initialize() {
    cornerRadius = 5
    backgroundColor = .black

    titleLbl.textColor = .white
    titleLbl.numberOfLines = 0
    titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)

    descLbl.textColor = .white
    descLbl.numberOfLines = 0
    descLbl.font = UIFont.preferredFont(forTextStyle: .body)

    let layout = UIStackView(arrangedSubviews: [
      titleLbl,
      descLbl
    ])
    .setAxis(.vertical)
    contentView.addSubview(layout)
    layout.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.all(5))
    }
  }

  override func cellDataChanged() {
    guard case let .text(data) = data else { return }
    titleLbl.text = data.title
    descLbl.text = data.description
  }
}

class CollectionImageCell: CollectionCell<SectionListItem> {
  let netImageView = UIImageView()

  override func initialize() {
    cornerRadius = 5

    netImageView.contentMode = .scaleAspectFill
    netImageView.clipsToBounds = true
    contentView.addSubview(netImageView)
    netImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func cellDataChanged() {
    guard case let .image(data) = data,
          let url = URL(string: data.url)
    else { return }
    netImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.25))
  }
}
