//
//  ListView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/28/18.
//

import UIKit

open class ListView<VM: IListViewModel>: View<VM> {
  public typealias Section = VM.Section
  public typealias Item = VM.Item
  public typealias DataSource = ListDataSource<Section, Item>

  public let tableView: UITableView

  private lazy var dataSource = DataSource(
    tableView: tableView,
    cellProvider: prepareCell,
    titleForHeaderInSection: titleForHeader,
    titleForFooterInSection: titleForFooter,
    canEditRowAtIndexPath: canEdit,
    canMoveRowAtIndexPath: canMove,
    sectionIndexTitles: sectionIndexTitles,
    sectionForSectionIndexTitle: sectionForSectionIndexTitle
  )

  public init(viewModel: VM, style: UITableView.Style = .plain) {
    tableView = UITableView(frame: .zero, style: style)
    super.init(viewModel: viewModel)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(viewModel:style:)")
  }

  override func setup() {
    tableView.backgroundColor = .clear
    addSubview(tableView)
    super.setup()
  }

  override open func initialize() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override open func destroy() {
    super.destroy()
  }

  /// Every time the viewModel changed, this method will be called again, so make sure to call super for ListPage to work
  override open func bindViewAndViewModel() {
    tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
      self?.itemSelected(indexPath)
    }) => disposeBag

    viewModel.itemsSource.snapshotChanged
      .observe(on: Scheduler.shared.mainScheduler)
      .subscribe(onNext: { [weak self] data in
        self?.snapshotChanged(data)
      }) => disposeBag
  }

  private func itemSelected(_ indexPath: IndexPath) {
    (viewModel as? IntenalListViewModel)?.selectedIndexRelay.accept(indexPath)
    if let item = dataSource[indexPath] {
      viewModel.selectedItemDidChange(item)
      selectedItemDidChange(item)
    }
  }

  private func snapshotChanged(_ data: ItemSource<Section, Item>.DataSource?) {
    guard let data = data else { return }
    dataSource.apply(data.snapshot, animatingDifferences: data.animated)
  }

  // MARK: - Abstract for subclasses

  /**
   Subclasses have to override this method to return correct cell identifier based `CVM` type.
   */
  open func cellIdentifier(_ item: Item) -> String {
    fatalError("Subclasses have to implement this method.")
  }

  /**
   Subclasses override this method to handle cell pressed action.
   */
  open func selectedItemDidChange(_ item: Item) {}

  // MARK: - Table view datasources

  public func prepareCell(for tableView: UITableView, at indexPath: IndexPath, item: Item) -> UITableViewCell {
    let identifier = cellIdentifier(item)
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    if let cell = cell as? CellConfigurable {
      cell.setData(data: item)
    }

    return cell
  }

  open func titleForHeader(_ dataSource: DataSource, section: Int) -> String? {
    return nil
  }

  open func titleForFooter(_ dataSource: DataSource, section: Int) -> String? {
    return nil
  }

  open func canEdit(_ dataSource: DataSource, indexPath: IndexPath) -> Bool {
    return false
  }

  open func canMove(_ dataSource: DataSource, canMoveRowAt indexPath: IndexPath) -> Bool {
    return false
  }

  open func sectionIndexTitles(dataSource: DataSource) -> [String]? {
    return nil
  }

  open func sectionForSectionIndexTitle(_ dataSource: DataSource, title: String, at index: Int) -> Int {
    return 0
  }
}
