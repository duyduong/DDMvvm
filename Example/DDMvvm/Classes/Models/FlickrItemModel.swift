//
//  FlickrItemModel.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import DDMvvm

/*
 Here is an example response from Flickr api
 
 {
     "photos": {
         "page": 1,
         "pages": 10,
         "perpage": 100,
         "total": "1000",
         "photo": [
             {
                 "id": "30120187527",
                 "owner": "130295052@N08",
                 "secret": "3b04c01891",
                 "server": "1963",
                 "farm": 2,
                 "title": "",
                 "ispublic": 1,
                 "isfriend": 0,
                 "isfamily": 0
             }
         ]
     },
     "stat": "ok"
 }
 
 */

class FlickrSearchResponse: Model {
    
    var page = 1
    var pages = 1
    var photos = [FlickrItemModel]()
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        page <- map["photos.page"]
        pages <- map["photos.pages"]
        photos <- map["photos.photo"]
    }
}

class FlickrItemModel: Model {
    
    var imageUrl: URL {
        let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
        return URL(string: url)!
    }
    
    var id = ""
    var owner = ""
    var secret = ""
    var server = ""
    var farm = 0
    var title = ""
    
    /*
     if you don't want to use these properties, just remove them, I just want
     to show how to deserialize from json using ObjectMapper
     */
    var isPublic = true
    var isFriend = false
    var isFamily = false
    
    override func mapping(map: Map) {
        id <- map["id"]
        owner <- map["owner"]
        secret <- map["secret"]
        server <- map["server"]
        farm <- map["farm"]
        title <- map["title"]
        isPublic <- (map["ispublic"], IntToBoolTransform())
        isFriend <- (map["isfriend"], IntToBoolTransform())
        isFamily <- (map["isfamily"], IntToBoolTransform())
    }
}



