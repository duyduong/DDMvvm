//
//  SimpleCollectionPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

/*
 You can notice that, this page does not create own ViewModel, I reused the SimpleListPageViewModel
 Even the cell, it reused SimpleListPageCellViewModel
 This should be the characteristic of ViewModel, decoupling with View
 */
class SimpleCollectionPage: CollectionPage<SimpleListPageViewModel> {
  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let shuffleBtn = UIBarButtonItem(title: "Shuffle", style: .done, target: nil, action: nil)
  let padding: CGFloat = 5

  override func initialize() {
    // By default, collectionView will pin to 4 edges of superview
    // If you want to layout tableView differently, then remove this line
    super.initialize()

    navigationItem.rightBarButtonItems = [addBtn, shuffleBtn]

    collectionView.delegate = self
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumLineSpacing = padding
      layout.minimumInteritemSpacing = padding
      layout.sectionInset = .all(padding)
    }
    collectionView.register(
      SimpleCollectionPageCell.self,
      forCellWithReuseIdentifier: SimpleCollectionPageCell.identifier
    )
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.add()
    }) => disposeBag

    shuffleBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.shuffle()
    }) => disposeBag
  }

  override func cellIdentifier(_ item: String) -> String {
    return SimpleCollectionPageCell.identifier
  }
}

extension SimpleCollectionPage: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let viewWidth = collectionView.frame.width

    let numOfCols: CGFloat
    if viewWidth <= 375 {
      numOfCols = 2
    } else if viewWidth <= 568 {
      numOfCols = 3
    } else if viewWidth <= 768 {
      numOfCols = 4
    } else {
      numOfCols = 5
    }

    let contentWidth = viewWidth - ((numOfCols + 1) * padding)
    let width = contentWidth / numOfCols
    return CGSize(width: width, height: 60)
  }
}
