//
//  ExampleMenuPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

enum SingleSection {
  case main
}

class ExampleMenuPage<Item: Menu>: ListPage<ExampleMenuPageViewModel<Item>> {
  override func initialize() {
    super.initialize()

    tableView.estimatedRowHeight = 200
    tableView.register(ExampleMenuCell.self, forCellReuseIdentifier: ExampleMenuCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()
    viewModel.rxPageTitle ~> rx.title => disposeBag
  }

  override func cellIdentifier(_ item: Item) -> String {
    ExampleMenuCell.identifier
  }

  override func selectedItemDidChange(_ item: Item) {
    guard let indexPath = viewModel.itemsSource[item: item] else {
      return
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

class ExampleMenuPageViewModel<Item: Menu>: ListViewModel<SingleSection, Item> {
  let rxPageTitle = BehaviorRelay<String?>(value: nil)
  
  init(title: String) {
    rxPageTitle.accept(title)
    super.init()
  }

  override func initialize() {
    itemsSource.update(animated: true) { snapshot in
      var newSnapshot = DiffableDataSourceSnapshot<SingleSection, Item>()
      newSnapshot.appendSections([.main])
      newSnapshot.appendItems(prepareMenus())
      snapshot = newSnapshot
    }
  }

  override func selectedItemDidChange(_ item: Item) {
    router?.route(to: item, transition: .default)
  }

  func prepareMenus() -> [Item] {
    return []
  }
}
