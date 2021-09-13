//
//  ListDataSource.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 8/25/20.
//

import UIKit

public class ListDataSource<Section: Hashable, Item: Hashable>: TableViewDiffableDataSource<Section, Item> {
  typealias DataSource = ListDataSource<Section, Item>
  typealias TitleForHeaderInSection = (DataSource, Int) -> String?
  typealias TitleForFooterInSection = (DataSource, Int) -> String?
  typealias CanEditRowAtIndexPath = (DataSource, IndexPath) -> Bool
  typealias CanMoveRowAtIndexPath = (DataSource, IndexPath) -> Bool
  typealias SectionIndexTitles = (DataSource) -> [String]?
  typealias SectionForSectionIndexTitle = (DataSource, _ title: String, _ index: Int) -> Int

  var titleForHeaderInSection: TitleForHeaderInSection
  var titleForFooterInSection: TitleForFooterInSection
  var canEditRowAtIndexPath: CanEditRowAtIndexPath
  var canMoveRowAtIndexPath: CanMoveRowAtIndexPath
  var sectionIndexTitles: SectionIndexTitles
  var sectionForSectionIndexTitle: SectionForSectionIndexTitle

  public subscript(indexPath: IndexPath) -> Item? {
    itemIdentifier(for: indexPath)
  }

  init(
    tableView: UITableView,
    cellProvider: @escaping CellProvider,
    titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
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

  override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleForHeaderInSection(self, section)
  }

  override public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return titleForFooterInSection(self, section)
  }

  override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return canEditRowAtIndexPath(self, indexPath)
  }

  override public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return canMoveRowAtIndexPath(self, indexPath)
  }

  public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sectionIndexTitles(self)
  }

  override public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return sectionForSectionIndexTitle(self, title, index)
  }
}
