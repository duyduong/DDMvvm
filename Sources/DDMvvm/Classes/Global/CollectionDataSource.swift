//
//  CollectionDataSource.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import UIKit

public class CollectionDataSource<Section: Hashable, Cell: Hashable>: CollectionViewDiffableDataSource<Section, Cell> {
  typealias CanMoveRowAtIndexPath = (CollectionDataSource<Section, Cell>, IndexPath) -> Bool

  var canMoveRowAtIndexPath: CanMoveRowAtIndexPath

  public subscript(indexPath: IndexPath) -> Cell? {
    return itemIdentifier(for: indexPath)
  }

  init(
    collectionView: UICollectionView,
    cellProvider: @escaping CellProvider,
    supplementaryViewProvider: @escaping SupplementaryViewProvider,
    canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath
  ) {
    self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
    super.init(collectionView: collectionView, cellProvider: cellProvider)
    self.supplementaryViewProvider = supplementaryViewProvider
  }

  override public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return canMoveRowAtIndexPath(self, indexPath)
  }
}
