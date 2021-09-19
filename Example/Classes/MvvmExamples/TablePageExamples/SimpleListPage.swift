//
//  SimpleListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

class SimpleListPage: ListPage<SimpleListPageViewModel> {
  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let shuffleBtn = UIBarButtonItem(title: "Shuffle", style: .done, target: nil, action: nil)

  override func initialize() {
    // By default, tableView will pin to 4 edges of superview
    // If you want to layout tableView differently, then remove this line
    super.initialize()

    navigationItem.rightBarButtonItems = [addBtn, shuffleBtn]

    tableView.estimatedRowHeight = 100
    tableView.register(SimpleListPageCell.self, forCellReuseIdentifier: SimpleListPageCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addBtn.rx.tap.subscribe(onNext: { [weak self] in
       self?.viewModel.add()
    }) => disposeBag
    
    shuffleBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.shuffle()
    }) => disposeBag
  }

  override func cellIdentifier(_ item: String) -> String {
    SimpleListPageCell.identifier
  }
}

class SimpleListPageViewModel: ListViewModel<SingleSection, String> {
  func add() {
    itemsSource.update(animated: true) { snapshot in
      var newSnapshot = DataSourceSnapshot()
      newSnapshot.appendSections([.main])

      var items = snapshot.itemIdentifiers
      let number = Int.random(in: 1_000 ... 10_000)
      let title = "This is your random number: \(number)"
      items.append(title)
      newSnapshot.appendItems(items)

      snapshot = newSnapshot
    }
  }
  
  func shuffle() {
    itemsSource.update(animated: true) { snapshot in
      var newSnapshot = DataSourceSnapshot()
      newSnapshot.appendSections([.main])

      var items = snapshot.itemIdentifiers
      items.shuffle()
      newSnapshot.appendItems(items)

      snapshot = newSnapshot
    }
  }
}
