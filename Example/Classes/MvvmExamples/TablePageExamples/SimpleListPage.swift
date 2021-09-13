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

  override func initialize() {
    // By default, tableView will pin to 4 edges of superview
    // If you want to layout tableView differently, then remove this line
    super.initialize()

    navigationItem.rightBarButtonItem = addBtn

    tableView.estimatedRowHeight = 100
    tableView.register(SimpleListPageCell.self, forCellReuseIdentifier: SimpleListPageCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addBtn.rx.tap.subscribe(onNext: { [weak self] in
       self?.viewModel.add()
    }) => disposeBag
  }

  override func cellIdentifier(_ item: String) -> String {
    return SimpleListPageCell.identifier
  }
}

class SimpleListPageViewModel: ListViewModel<SingleSection, String> {
  func add() {
    itemsSource.update { snapshot in
      if snapshot.numberOfSections == 0 {
        snapshot.appendSections([.main])
      }

      let number = Int.random(in: 1_000 ... 10_000)
      let title = "This is your random number: \(number)"
      snapshot.appendItems([title])
    }
  }
}
