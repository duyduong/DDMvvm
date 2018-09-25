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
        view.backgroundColor = .white
        
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addBtn
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
}

class ContactListPageViewModel: ListViewModel<Model, SuperCellViewModel> {
    
    lazy var addAction: Action<Void, Void> = {
        return Action() {
            let page = ContactPage(viewModel: ContactPageViewModel())
            self.navigationService.push(to: page)
            return .just(())
        }
    }()
    
    override func react() {
        
    }
}
