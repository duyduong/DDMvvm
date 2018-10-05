//
//  ContactModel.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import DDMvvm
import ObjectMapper

class ContactModel: Model {
    
    var name = ""
    var phone = ""
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        phone <- map["phone"]
    }
}











