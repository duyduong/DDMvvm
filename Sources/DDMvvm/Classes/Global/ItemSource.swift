//
//  ItemSource.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import RxCocoa
import RxSwift

public struct ItemSource<Section: Hashable, Item: Hashable> {
  public typealias DataSourceSnapshot = DiffableDataSourceSnapshot<Section, Item>

  /// Snapshot data wraper
  public struct SnapshotData {
    public let snapshot: DataSourceSnapshot
    public let animated: Bool
  }

  private let rxSnapshotData = BehaviorRelay(
    value: SnapshotData(snapshot: DataSourceSnapshot(), animated: false)
  )
  var snapshotDataUpdated: Observable<SnapshotData> { rxSnapshotData.asObservable() }
  public var snapshot: DataSourceSnapshot { rxSnapshotData.value.snapshot }

  /// Whether to animate the changes
  public var animated = false

  /// Update itemsSource with new snapshot
  /// - Parameters:
  ///   - animated: Individually animate this change
  ///   - block: Snapshot preparation block
  public func update(animated: Bool? = nil, block: (inout DataSourceSnapshot) -> Void) {
    var snapshot = self.snapshot
    block(&snapshot)
    rxSnapshotData.accept(.init(snapshot: snapshot, animated: animated ?? self.animated))
  }

  // MARK: - Subscripts

  public subscript(item item: Item) -> IndexPath? {
    for (i, section) in snapshot.sectionIdentifiers.enumerated() {
      let sectionItems = snapshot.itemIdentifiers(inSection: section)
      if let index = sectionItems.firstIndex(of: item) {
        return IndexPath(item: index, section: i)
      }
    }
    return nil
  }

  public subscript(index index: Int, section section: Int) -> Item? {
    guard let section = snapshot.sectionIdentifiers[safe: section] else {
      return nil
    }
    return snapshot.itemIdentifiers(inSection: section)[safe: index]
  }
  
  public subscript(index index: Int, section section: Section) -> Item? {
    let sectionItems = snapshot.itemIdentifiers(inSection: section)
    return sectionItems[safe: index]
  }
}
