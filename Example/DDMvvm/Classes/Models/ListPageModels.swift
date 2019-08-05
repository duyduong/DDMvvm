//
//  ListPageModels.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import DDMvvm

class SimpleModel: Model {
    
    var title = ""
    
    convenience init(withTitle title: String) {
        self.init(JSON: ["title": title])!
    }
    
    override func mapping(map: Map) {
        title <- map["title"]
    }
}

class NumberModel: Model {
    
    var number = Int.random(in: 0..<200000)
}

class SectionTextModel: NumberModel {
    
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

class SectionImageModel: NumberModel {
    
    var imageUrl: URL?
    
    convenience init(withUrl url: String) {
        self.init(JSON: ["url": url])!
    }
    
    override func mapping(map: Map) {
        imageUrl <- (map["url"], URLTransform())
    }
}






