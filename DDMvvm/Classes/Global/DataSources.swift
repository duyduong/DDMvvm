//
//  DataSources.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 8/25/20.
//

import DiffableDataSources

public class ListDataSource<S: Hashable, I: Hashable>: TableViewDiffableDataSource<S, I> {
    
    typealias TitleForHeaderInSection = (ListDataSource<S, I>, Int) -> String?
    typealias TitleForFooterInSection = (ListDataSource<S, I>, Int) -> String?
    typealias CanEditRowAtIndexPath = (ListDataSource<S, I>, IndexPath) -> Bool
    typealias CanMoveRowAtIndexPath = (ListDataSource<S, I>, IndexPath) -> Bool
    typealias SectionIndexTitles = (ListDataSource<S, I>) -> [String]?
    typealias SectionForSectionIndexTitle = (ListDataSource<S, I>, _ title: String, _ index: Int) -> Int
    
    var titleForHeaderInSection: TitleForHeaderInSection
    var titleForFooterInSection: TitleForFooterInSection
    var canEditRowAtIndexPath: CanEditRowAtIndexPath
    var canMoveRowAtIndexPath: CanMoveRowAtIndexPath
    var sectionIndexTitles: SectionIndexTitles
    var sectionForSectionIndexTitle: SectionForSectionIndexTitle

    public subscript(indexPath: IndexPath) -> I? {
        return itemIdentifier(for: indexPath)
    }
    
    init(
        tableView: UITableView,
        cellProvider: @escaping CellProvider,
        titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
    ) {
        self.titleForHeaderInSection = titleForHeaderInSection
        self.titleForFooterInSection = titleForFooterInSection
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
        self.sectionIndexTitles = sectionIndexTitles
        self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(self, section)
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection(self, section)
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRowAtIndexPath(self, indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRowAtIndexPath(self, indexPath)
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles(self)
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle(self, title, index)
    }
}

public class CollectionDataSource<S: Hashable, I: Hashable>: CollectionViewDiffableDataSource<S, I> {
    
    typealias CanMoveRowAtIndexPath = (CollectionDataSource<S, I>, IndexPath) -> Bool
    
    var canMoveRowAtIndexPath: CanMoveRowAtIndexPath
    
    public subscript(indexPath: IndexPath) -> I? {
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
    
    public override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMoveRowAtIndexPath(self, indexPath)
    }
}
