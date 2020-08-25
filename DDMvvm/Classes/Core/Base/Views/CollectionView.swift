//
//  CollectionView.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/28/18.
//

import UIKit

open class CollectionView<VM: IListViewModel>: View<VM> {

    public typealias S = VM.SectionElement
    public typealias CVM = VM.CellElement
    
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var dataSource = CollectionDataSource<S, CVM>(
        collectionView: collectionView,
        cellProvider: prepareCell,
        supplementaryViewProvider: viewForSupplementaryElement,
        canMoveRowAtIndexPath: canMoveItem
    )
    
    public override init(viewModel: VM? = nil) {
        super.init(viewModel: viewModel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        addSubview(collectionView)
        super.setup()
    }
    
    /**
     Subclasses override this method to create its own collection view layout.
     
     By default, flow layout will be using.
     */
    open func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
    
    open override func initialize() {
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    open override func destroy() {
        super.destroy()
        collectionView.removeFromSuperview()
    }
    
    /// Every time the viewModel changed, this method will be called again, so make sure to call super for ListPage to work
    open override func bindViewAndViewModel() {
        collectionView.rx.itemSelected.subscribe(onNext: itemSelected) => disposeBag
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
    
    /**
     Subclasses have to override this method to return correct cell identifier based `CVM` type.
     */
    open func cellIdentifier(_ cellViewModel: CVM) -> String {
        fatalError("Subclasses have to implemented this method.")
    }
    
    /**
     Subclasses override this method to handle cell pressed action.
     */
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
    
    // MARK: - Collection view datasources
    
    func prepareCell(for collectionView: UICollectionView, at indexPath: IndexPath, cellViewModel: CVM) -> UICollectionViewCell {
        (cellViewModel as? IIndexable)?.indexPath = indexPath
        
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        return cell
    }
    
    open func viewForSupplementaryElement(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return (nil as UICollectionReusableView?)!
    }
    
    open func canMoveItem(_ dataSource: CollectionDataSource<S, CVM>, at indexPath: IndexPath) -> Bool {
        return false
    }
}
