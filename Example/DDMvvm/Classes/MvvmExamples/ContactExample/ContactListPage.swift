//
//  ContactListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Action
import DDMvvm

class ContactListPage: ListPage<ContactListPageViewModel> {

    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    override func initialize() {
        // By default, tableView will pin to 4 edges of superview
        // If you want to layout tableView differently, then remove this line
        super.initialize()
        
        title = "Contact List"
        
        enableBackButton = true
        
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.estimatedRowHeight = 150
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
    
    override func selectedItemDidChange(_ cellViewModel: ContactCellViewModel) {
        if let indexPath = viewModel?.rxSelectedIndex.value {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

class ContactListPageViewModel: ListViewModel<Model, ContactCellViewModel> {
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    override func selectedItemDidChange(_ cellViewModel: ContactCellViewModel) {
        handleContactModification(cellViewModel.model)
    }
    
    private func add() {
        handleContactModification()
    }
    
    private func handleContactModification(_ model: ContactModel? = nil) {
        let vm = ContactEditPageViewModel(model: model)
        let page = ContactEditPage(viewModel: vm)
        
        // as you are controlling the ViewModel of edit page,
        // so we can get the result out without using any Delegates
        vm.saveAction.executionObservables.switchLatest().subscribe(onNext: { contactModel in
            if model == nil {
                let cvm = ContactCellViewModel(model: contactModel)
                self.itemsSource.append(cvm)
            } else if let cvm = self.rxSelectedItem.value {
                cvm.model = contactModel
            }
        }) => disposeBag
        
//        navigationService.push(to: page)
        let navPage = WrapperPage(rootViewController: page)
        navigationService.push(to: navPage, options: PushOptions(pushType: .popup(.defaultOptions)))
    }
}










