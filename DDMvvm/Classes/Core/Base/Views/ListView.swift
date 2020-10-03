//
//  ListView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/28/18.
//

import UIKit

open class ListView<VM: IListViewModel>: View<VM> {

    public typealias S = VM.SectionElement
    public typealias CVM = VM.CellElement
    
    public let tableView: UITableView
    
    private lazy var dataSource = ListDataSource<S, CVM>(
        tableView: tableView,
        cellProvider: prepareCell,
        titleForHeaderInSection: titleForHeader,
        titleForFooterInSection: titleForFooter,
        canEditRowAtIndexPath: canEdit,
        canMoveRowAtIndexPath: canMove,
        sectionIndexTitles: sectionIndexTitles,
        sectionForSectionIndexTitle: sectionForSectionIndexTitle
    )
    
    public init(viewModel: VM? = nil, style: UITableView.Style = .plain) {
        tableView = UITableView(frame: .zero, style: style)
        super.init(viewModel: viewModel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        tableView.backgroundColor = .clear
        addSubview(tableView)
        
        super.setup()
    }
    
    open override func initialize() {
        tableView.autoPinEdgesToSuperviewEdges(with: .zero)
    }
    
    open override func destroy() {
        super.destroy()
        tableView.removeFromSuperview()
        tableView.visibleCells.forEach { ($0 as? IDestroyable)?.destroy() }
        for section in 0..<tableView.numberOfSections {
            let headerView = tableView.headerView(forSection: section)
            (headerView as? IDestroyable)?.destroy()
        }
    }
    
    /// Every time the viewModel changed, this method will be called again, so make sure to call super for ListPage to work
    open override func bindViewAndViewModel() {
        tableView.rx.itemSelected.subscribe(onNext: itemSelected) => disposeBag
        viewModel?.itemsSource.snapshotChanged
            .observeOn(Scheduler.shared.mainScheduler)
            .subscribe(onNext: snapshotChanged) => disposeBag
    }
    
    private func itemSelected(_ indexPath: IndexPath) {
        guard let viewModel = viewModel, let cellViewModel = dataSource[indexPath] else { return }

        viewModel.rxSelectedItem.accept(cellViewModel)
        viewModel.rxSelectedIndex.accept(indexPath)

        viewModel.selectedItemDidChange(cellViewModel)

        selectedItemDidChange(cellViewModel)
    }
    
    private func snapshotChanged(_ data: ItemSource<S, CVM>.Snapshot?) {
        guard let data = data else { return }
        let snapshot = data.snapshot
        let animated = data.animated
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: - Abstract for subclasses
    
    open func cellIdentifier(_ cellViewModel: CVM) -> String {
        fatalError("Subclasses have to implement this method.")
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
    
    // MARK: - Table view datasources
    
    public func prepareCell(for tableView: UITableView, at indexPath: IndexPath, cellViewModel: CVM) -> UITableViewCell {
        // set index for each cell
        (cellViewModel as? IIndexable)?.indexPath = indexPath
        
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        
        return cell
    }
    
    open func titleForHeader(_ dataSource: ListDataSource<S, CVM>, section: Int) -> String? {
        return nil
    }
    
    open func titleForFooter(_ dataSource: ListDataSource<S, CVM>, section: Int) -> String? {
        return nil
    }
    
    open func canEdit(_ dataSource: ListDataSource<S, CVM>, indexPath: IndexPath) -> Bool {
        return false
    }
    
    open func canMove(_ dataSource: ListDataSource<S, CVM>, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    open func sectionIndexTitles(dataSource: ListDataSource<S, CVM>) -> [String]? {
        return nil
    }
    
    open func sectionForSectionIndexTitle(_ dataSource: ListDataSource<S, CVM>, title: String, at index: Int) -> Int {
        return 0
    }
}
