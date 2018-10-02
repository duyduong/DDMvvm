//
//  MenuModel.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import DDMvvm
import ObjectMapper

class MenuModel: Model {
    
    var title = ""
    var desc = ""
    
    convenience init(withTitle title: String, desc: String) {
        self.init(JSON: ["title": title, "desc": desc])!
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
    }
}

