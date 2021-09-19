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

enum SectionListItem: Hashable {
  struct ImageData: Hashable {
    let id = UUID().uuidString
    let url: String
  }
  
  struct TextData: Hashable {
    let id = UUID().uuidString
    let title: String
    let description: String
  }
  
  case image(data: ImageData)
  case text(data: TextData)
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
    guard case let .text(data) = data else { return }
    titleLbl.text = data.title
    descLbl.text = data.description
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
    guard case let .image(data) = data,
          let url = URL(string: data.url)
    else { return }
    netImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.25))
  }
}
