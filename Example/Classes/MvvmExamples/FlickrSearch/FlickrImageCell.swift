//
//  FlickerImageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

class FlickrImageCell: CollectionCell<FlickrSearchResponse.Photo> {
  let imageView = UIImageView()
  let titleLbl = UILabel()

  override func initialize() {
    contentView.cornerRadius = 7

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    let titleView = UIView()
    titleView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
    contentView.addSubview(titleView)
    titleView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
    }

    titleLbl.font = UIFont.preferredFont(forTextStyle: .body)
    titleLbl.textColor = .white
    titleLbl.numberOfLines = 2
    titleView.addSubview(titleLbl)
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.all(5))
    }
  }
  
  override func cellDataChanged() {
    guard let photo = data else { return }
    imageView.af.setImage(withURL: photo.imageUrl)
    titleLbl.text = photo.title
  }
}
