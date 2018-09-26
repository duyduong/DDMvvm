//
//  ContactPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class ContactPage: DDPage<ContactPageViewModel> {

    override func initialize() {
        enableBackButton = true
    }
}

class ContactPageViewModel: ViewModel<Model> {
    
    override func react() {
        
    }
}
