//
//  CollectionPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

open class CollectionPage<VM: IListViewModel>: Page<VM>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public typealias CVM = VM.CellViewModelElement

    public private(set) var collectionView: UICollectionView!
    public var layout: UICollectionViewLayout!
    
    private var counter = [Int: Int]()

    public override init(viewModel: VM? = nil) {
        super.init(viewModel: viewModel)
        setupCollectionView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        layout = collectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    override open func viewDidLoad() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        super.viewDidLoad()
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.layout.invalidateLayout()
        }, completion: nil)
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
    
    @available(*, deprecated, message: "CollectionPage no longer support this func. Please override layout property")
    open func setupLayout() {
        layout = UICollectionViewFlowLayout()
    }

    open override func initialize() {
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    open override func destroy() {
        super.destroy()
        collectionView.removeFromSuperview()
    }

    open override func localHudToggled(_ value: Bool) {
        collectionView.isHidden = value
    }

    open override func bindViewAndViewModel() {
        updateCounter()
        collectionView.reloadData()
        
        collectionView.rx.itemSelected.asObservable().subscribe(onNext: onItemSelected) => disposeBag
        viewModel?.itemsSource.collectionChanged.subscribe(onNext: onDataSourceChanged) => disposeBag
    }

    private func onItemSelected(_ indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let cellViewModel = viewModel.itemsSource[indexPath.row, indexPath.section]
        
        viewModel.rxSelectedItem.accept(cellViewModel)
        viewModel.rxSelectedIndex.accept(indexPath)
        
        viewModel.selectedItemDidChange(cellViewModel)
        selectedItemDidChange(cellViewModel)
    }
    
    private func onDataSourceChanged(_ changeSet: ChangeSet) {
        collectionView.performBatchUpdates({
            switch changeSet {
            case .insertSection(let section):
                collectionView.insertSections(IndexSet([section]))
                
            case .deleteSection(let section):
                if section < 0 {
                    if collectionView.numberOfSections > 0 {
                        let sections = Array(0...collectionView.numberOfSections - 1)
                        collectionView.deleteSections(IndexSet(sections))
                    }
                } else {
                    collectionView.deleteSections(IndexSet([section]))
                }
                
            case .insertElements(let indice, let section):
                let indexPaths = indice.map { IndexPath(row: $0, section: section) }
                collectionView.insertItems(at: indexPaths)
                
            case .deleteElements(let indice, let section):
                let indexPaths = indice.map { IndexPath(row: $0, section: section) }
                collectionView.deleteItems(at: indexPaths)
            }
            
            // update counter
            updateCounter()
        }, completion: nil)
    }
    
    private func updateCounter() {
        counter.removeAll()
        viewModel?.itemsSource.forEach { counter[$0] = $1.count }
    }
    
    // MARK: - Abstract for subclasses
    
    open func cellIdentifier(_ cellViewModel: CVM) -> String {
        fatalError("Subclasses have to implemented this method.")
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
    
    // MARK: - Collection view datasources
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return counter.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counter[section] ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell(frame: .zero)
        }
        
        let cellViewModel = viewModel.itemsSource[indexPath.row, indexPath.section]
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return (nil as UICollectionReusableView?)!
    }
    
    // MARK: - Collection view delegates
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}













