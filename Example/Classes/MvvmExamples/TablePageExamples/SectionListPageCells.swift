//
//  SectionListPageCells.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

struct SectionListItem: Hashable {
  enum ItemType: Hashable {
    case image(url: String)
    case text(title: String, description: String)
  }
  
  let type: ItemType
  let number = Int.random(in: 0 ..< 200_000)
}

class SectionTextCell: TableCell<SectionListItem> {

  let titleLbl = UILabel()
  let descLbl = UILabel()

  override func initialize() {
    titleLbl.numberOfLines = 0
    titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)

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
    guard case let .text(title, description) = data?.type else { return }
    titleLbl.text = title
    descLbl.text = description
  }
}

class SectionImageCell: TableCell<SectionListItem> {
  let netImageView = UIImageView()

  override func initialize() {
    netImageView.contentMode = .scaleAspectFill
    netImageView.clipsToBounds = true
    contentView.addSubview(netImageView)
    netImageView.snp.makeConstraints {
      $0.height.equalTo(netImageView.snp.width).multipliedBy(9/16.0)
      $0.edges.equalToSuperview().inset(UIEdgeInsets.symmetric(horizontal: 15, vertical: 10))
    }
  }
  
  override func cellDataChanged() {
    guard case let .image(urlString) = data?.type,
          let url = URL(string: urlString)
    else { return }
    netImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.25))
  }
}
