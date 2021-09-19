//
//  CollectionPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

open class CollectionPage<VM: IListViewModel>: Page<VM> {
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

  override open func viewDidLoad() {
    view.addSubview(collectionView)
    super.viewDidLoad()
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.backgroundView = nil
  }

  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
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
    if let item = dataSource[indexPath] {
      viewModel.selectedItemDidChange(item)
      selectedItemDidChange(item)
    }
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
    (cell as? CellConfigurable)?.setData(data: item)
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
