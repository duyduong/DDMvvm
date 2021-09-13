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

  init() {
    update { $0.appendSections([]) }
  }

  /// Update itemsSource with new snapshot
  public func update(animated: Bool = false, block: (inout DataSourceSnapshot) -> Void) {
    var snapshot = self.snapshot ?? DataSourceSnapshot()
    block(&snapshot)
    rxSnapshot.accept(DataSource(snapshot: snapshot, animated: animated))
  }

  // MARK: - Subscripts

  public subscript(indexPath indexPath: IndexPath) -> Item? {
    guard let section = snapshot?.sectionIdentifiers[safe: indexPath.section] else {
      return nil
    }
    return snapshot?.itemIdentifiers(inSection: section)[safe: indexPath.item]
  }

  public subscript(index index: Int, section section: Int) -> Item? {
    guard let section = snapshot?.sectionIdentifiers[safe: section] else {
      return nil
    }
    return snapshot?.itemIdentifiers(inSection: section)[safe: index]
  }
}
