//
//  SectionListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import RxSwift
import UIKit

class SectionListPage: ListPage<SectionListPageViewModel> {
  let addSectionBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let shuffleBtn = UIBarButtonItem(title: "Shuffle", style: .done, target: nil, action: nil)
  
  // Cache headers
  var cacheHeaders: [SectionList: SectionHeaderView] = [:]

  override func initialize() {
    super.initialize()

    navigationItem.rightBarButtonItems = [addSectionBtn, shuffleBtn]

    tableView.delegate = self
    tableView.estimatedRowHeight = 300
    tableView.register(SectionTextCell.self, forCellReuseIdentifier: SectionTextCell.identifier)
    tableView.register(SectionImageCell.self, forCellReuseIdentifier: SectionImageCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addSectionBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.addSection()
    }) => disposeBag

    shuffleBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.shuffle()
    }) => disposeBag
  }

  // Based on type to return correct identifier for cells
  override func cellIdentifier(_ item: SectionListItem) -> String {
    switch item.type {
    case .image: return SectionImageCell.identifier
    case .text: return SectionTextCell.identifier
    }
  }
  
  override func destroy() {
    super.destroy()
    cacheHeaders.forEach { $1.destroy() }
    cacheHeaders = [:]
  }
}

extension SectionListPage: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let section = viewModel.itemsSource.snapshot?.sectionIdentifiers[section] else {
      return nil
    }
    
    // If there is cache header, use it
    if let headerView = cacheHeaders[section] {
      return headerView
    }

    // Otherwise create new one, and save cache
    let headerView = SectionHeaderView(section: section)
    cacheHeaders[section] = headerView
    headerView.rx.addSectionObservable
      .subscribe(onNext: { [weak self] section in
        self?.viewModel.addItem(to: section)
      }) => disposeBag
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }
}

enum SectionList: Hashable {
  case single(title: String)
}

class SectionListPageViewModel: ListViewModel<SectionList, SectionListItem> {
  let imageUrls = [
    "https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=350",
    "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&h=350",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3cP_SZVm5g43t4U8slThjjp6v1dGoUyfPd6ncEvVQQG1LzDl",
    "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&h=350"
  ]

  func addItem(to section: SectionList) {
    let randomIndex = Int.random(in: 0 ... 1)

    // randomly show text cell or image cell
    if randomIndex == 0 {
      // ramdom image from imageUrls
      let index = Int.random(in: 0 ..< imageUrls.count)
      let url = imageUrls[index]

      itemsSource.update(animated: true) { snapshot in
        snapshot.appendItems([.init(type: .image(url: url))], toSection: section)
      }
    } else {
      itemsSource.update(animated: true) { snapshot in
        snapshot.appendItems([
          .init(type: .text(title: "Just a text cell title", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."))
        ], toSection: section)
      }
    }
  }

  /// Add new section
  func addSection() {
    let count = itemsSource.snapshot?.numberOfSections ?? 0
    let section: SectionList = .single(title: "Section title #\(count + 1)")
    itemsSource.update(animated: true) { snapshot in
      snapshot.appendSections([section])
    }
  }

  /// Shuffle a random section
  func shuffle() {
    guard let section = itemsSource.snapshot?.sectionIdentifiers.randomElement() else { return }
    itemsSource.update(animated: true) { snapshot in
      var items = snapshot.itemIdentifiers(inSection: section)
      items.shuffle()
      snapshot.reloadItems(items)
    }
  }
}
