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
  public struct DataSource {
    public let snapshot: DataSourceSnapshot
    public let animated: Bool
  }

  private let rxSnapshot = BehaviorRelay<DataSource?>(value: nil)

  /// Snapshot change observable
  public var snapshotChanged: Observable<DataSource?> { rxSnapshot.asObservable() }

  /// Current snapshot
  public var snapshot: DataSourceSnapshot? { rxSnapshot.value?.snapshot }

  /// Whether to animate the changes
  public var animated = false

  init() {
    update { $0.appendSections([]) }
  }

  /// Update itemsSource with new snapshot
  /// - Parameters:
  ///   - animated: Individually animate this change
  ///   - block: Snapshot preparation block
  public func update(animated: Bool? = nil, block: (inout DataSourceSnapshot) -> Void) {
    var snapshot = self.snapshot ?? DataSourceSnapshot()
    block(&snapshot)
    rxSnapshot.accept(DataSource(snapshot: snapshot, animated: animated ?? self.animated))
  }

  // MARK: - Subscripts

  public subscript(item item: Item) -> IndexPath? {
    guard let snapshot = snapshot else { return nil }
    for (i, section) in snapshot.sectionIdentifiers.enumerated() {
      let sectionItems = snapshot.itemIdentifiers(inSection: section)
      if let index = sectionItems.firstIndex(of: item) {
        return IndexPath(item: index, section: i)
      }
    }
    return nil
  }

  public subscript(index index: Int, section section: Int) -> Item? {
    guard let section = snapshot?.sectionIdentifiers[safe: section] else {
      return nil
    }
    return snapshot?.itemIdentifiers(inSection: section)[safe: index]
  }
  
  public subscript(index index: Int, section section: Section) -> Item? {
    guard let sectionItems = snapshot?.itemIdentifiers(inSection: section) else {
      return nil
    }
    return sectionItems[safe: index]
  }
}
