//
//  ContactListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm
import Action

class ContactListPage: BasePage_TableView<ContactListPageViewModel> {
    
    var addBtn: UIBarButtonItem!
    
    override func initialize() {
        super.initialize()
        
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.estimatedRowHeight = 100
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    override func cellIdentifier(_ cellViewModel: ContactCellViewModel) -> String {
        return ContactCell.identifier
    }
}

class ContactListPageViewModel: ListViewModel<Model, ContactCellViewModel> {
    
    private var count = 1
    
    lazy var addAction: Action<Void, Void> = {
        return Action() {
            let contactModel = ContactModel(withName: "Contact name #\(self.count)")
            self.itemsSource.append(ContactCellViewModel(model: contactModel))
            
            self.count += 1
            
            return .just(())
        }
    }()
    
    override func react() {
        
    }
}
