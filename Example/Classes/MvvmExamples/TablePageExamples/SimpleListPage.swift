//
//  SimpleListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class SimpleListPage: ListPage<SimpleListPageViewModel> {
    
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func initialize() {
        // By default, tableView will pin to 4 edges of superview
        // If you want to layout tableView differently, then remove this line
        super.initialize()
        
        enableBackButton = true
        
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.estimatedRowHeight = 100
        tableView.register(SimpleListPageCell.self, forCellReuseIdentifier: SimpleListPageCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel?.add()
        }) => disposeBag
    }
    
    override func cellIdentifier(_ cellViewModel: SimpleListPageCellViewModel) -> String {
        return SimpleListPageCell.identifier
    }
}

class SimpleListPageViewModel: ListViewModel<Any, SingleSection, SimpleListPageCellViewModel> {
    
    func add() {
        let number = Int.random(in: 1000...10000)
        let title = "This is your random number: \(number)"
        let cvm = SimpleListPageCellViewModel(model: SimpleModel(title: title))
        itemsSource.update { snapshot in
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            
            snapshot.appendItems([cvm])
        }
    }
}










