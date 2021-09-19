//
//  ContactCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

class ContactCell: TableCell<Contact> {
  let avatarIv = UIImageView()
  let nameLbl = UILabel()
  let phoneLbl = UILabel()

  override func initialize() {
    contentView.backgroundColor = .white
    if #available(iOS 13.0, *) {
      avatarIv.image = UIImage(systemName: "person.circle")
    }
    avatarIv.tintColor = .black
    avatarIv.snp.makeConstraints {
      $0.width.height.equalTo(64)
    }

    nameLbl.numberOfLines = 0
    nameLbl.font = UIFont.preferredFont(forTextStyle: .headline)

    phoneLbl.numberOfLines = 0
    phoneLbl.font = UIFont.preferredFont(forTextStyle: .body)

    let layout = UIStackView(arrangedSubviews: [
      avatarIv,
      UIStackView(arrangedSubviews: [
        nameLbl,
        phoneLbl
      ])
      .setAxis(.vertical)
    ])
    .setSpacing(8)
    .setAlignment(.center)
    contentView.addSubview(layout)
    layout.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(NSDirectionalEdgeInsets.all(5))
    }
  }
  
  override func cellDataChanged() {
    guard let data = data else { return }
    nameLbl.text = data.name
    phoneLbl.text = data.phone
  }
}

