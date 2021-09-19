//
//  CollectionView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/28/18.
//

import UIKit

open class CollectionView<VM: IListViewModel>: View<VM> {
  public typealias Section = VM.Section
  public typealias Item = VM.Item
  public typealias DataSource = CollectionDataSource<Section, Item>

  public private(set) lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: collectionViewLayout()
    )
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  private lazy var dataSource = DataSource(
    collectionView: collectionView,
    cellProvider: prepareCell,
    supplementaryViewProvider: viewForSupplementaryElement,
    canMoveRowAtIndexPath: canMoveItem
  )

  override public init(viewModel: VM) {
    super.init(viewModel: viewModel)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(viewModel:)")
  }

  override func setup() {
    addSubview(collectionView)
    super.setup()
  }

  /**
   Subclasses override this method to create its own collection view layout.

   By default, flow layout will be used.
   */
  open func collectionViewLayout() -> UICollectionViewLayout {
    return UICollectionViewFlowLayout()
  }

  override open func initialize() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override open func destroy() {
    super.destroy()
  }

  /// Every time the viewModel changed, this method will be called again, so make sure to call super for CollectionPage to work
  override open func bindViewAndViewModel() {
    collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
      self?.itemSelected(indexPath)
    }) => disposeBag

    viewModel.itemsSource.snapshotDataUpdated
      .observe(on: Scheduler.shared.mainScheduler)
      .subscribe(onNext: { [weak self] data in
        self?.snapshotDataChanged(data)
      }) => disposeBag
  }

  private func itemSelected(_ indexPath: IndexPath) {
    (viewModel as? IntenalListViewModel)?.selectedIndexRelay.accept(indexPath)
    guard let item = dataSource[indexPath] else { return }
    viewModel.selectedItemDidChange(item)
    selectedItemDidChange(item)
  }

  private func snapshotDataChanged(_ data: ItemSource<Section, Item>.SnapshotData) {
    dataSource.apply(
      data.snapshot,
      animatingDifferences: data.animated
    )
  }

  // MARK: - Abstract for subclasses

  /**
   Subclasses have to override this method to return correct cell identifier based `CVM` type.
   */
  open func cellIdentifier(_ item: Item) -> String {
    fatalError("Subclasses have to implemented this method.")
  }

  /**
   Subclasses override this method to handle cell pressed action.
   */
  open func selectedItemDidChange(_ item: Item) {}

  // MARK: - Collection view datasources

  func prepareCell(for collectionView: UICollectionView, at indexPath: IndexPath, item: Item) -> UICollectionViewCell {
    let identifier = cellIdentifier(item)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    if let cell = cell as? CellConfigurable {
      cell.setData(data: item)
    }
    return cell
  }

  open func viewForSupplementaryElement(
    for collectionView: UICollectionView,
    kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    return (nil as UICollectionReusableView?)!
  }

  open func canMoveItem(_ dataSource: DataSource, at indexPath: IndexPath) -> Bool {
    return false
  }
}
