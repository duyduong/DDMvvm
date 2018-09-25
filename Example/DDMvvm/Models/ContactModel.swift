//
//  ContactModel.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/26/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import DDMvvm

class ContactModel: Model {
    
    var name = ""
    
    convenience init(withName name: String) {
        self.init(JSON: ["name": name])!
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
    }
}





