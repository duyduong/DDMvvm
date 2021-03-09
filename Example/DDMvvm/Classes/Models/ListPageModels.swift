//
//  ListPageModels.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct SimpleModel {
    var title: String
}

struct NumberModel {
    var number = Int.random(in: 0..<200000)
}

struct SectionTextModel {
    
    var number = Int.random(in: 0..<200000)
    var title: String
    var desc: String
}

struct SectionImageModel {
    var number = Int.random(in: 0..<200000)
    var imageUrl: URL
}






