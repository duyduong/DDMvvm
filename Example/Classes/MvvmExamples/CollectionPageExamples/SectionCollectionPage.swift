//
//  SectionCollectionPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

/*
 You can notice that, this page does not create own ViewModel, I reused the SectionListPageViewModel
 Even the cells, it reused SectionTextCellViewModel and SectionImageCellViewModel
 This should be the characteristic of ViewModel, decoupling with View
 */
class SectionCollectionPage: CollectionPage<SectionListPageViewModel> {
  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let padding: CGFloat = 5

  override func initialize() {
    super.initialize()

    navigationItem.rightBarButtonItem = addBtn

    collectionView.delegate = self
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.sectionHeadersPinToVisibleBounds = true
      layout.minimumLineSpacing = padding
      layout.minimumInteritemSpacing = padding
      layout.sectionInset = .all(padding)
    }
    collectionView.register(
      SectionHeaderCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderCell.identifier
    )
    collectionView.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identifier)
    collectionView.register(CollectionImageCell.self, forCellWithReuseIdentifier: CollectionImageCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.addSection()
    }) => disposeBag
  }

  // Based on cellViewModel type, we can return correct identifier for cells
  override func cellIdentifier(_ item: SectionListItem) -> String {
    switch item.type {
    case .image: return CollectionImageCell.identifier
    case .text: return CollectionTextCell.identifier
    }
  }

  /// Setup section header cell, each header cell will map with key from itemsSource
  override func viewForSupplementaryElement(
    for collectionView: UICollectionView,
    kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let cell = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SectionHeaderCell.identifier,
        for: indexPath
      ) as! SectionHeaderCell
      
      cell.rx.addSectionObservable.subscribe(onNext: { [weak self] section in
        self?.viewModel.addItem(to: section)
      }) => cell.disposeBag
      
      if let section = viewModel.itemsSource.snapshot?.sectionIdentifiers[safe: indexPath.section] {
        cell.data = section
      }
      return cell
    }

    return super.viewForSupplementaryElement(for: collectionView, kind: kind, at: indexPath)
  }
}

extension SectionCollectionPage: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 44)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let viewWidth = collectionView.frame.width
    let numOfCols: CGFloat = 2 // collectionView.frame.width > collectionView.frame.height ? 2 : 1

    let contentWidth = viewWidth - ((numOfCols + 1) * padding)
    let width = contentWidth / numOfCols
    return CGSize(width: width, height: 9 * width / 16)
  }
}
