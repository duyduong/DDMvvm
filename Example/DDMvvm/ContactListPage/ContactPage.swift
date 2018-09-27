//
//  ContactPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class ContactPage: Page<ContactPageViewModel> {

    override func initialize() {
        view.backgroundColor = .red
        enableBackButton = true
    }
    
    override func onBack() {
        navigationService.pop(for: .dismiss)
    }
}

class ContactPageViewModel: ViewModel<Model> {
    
    override func react() {
        
    }
}
