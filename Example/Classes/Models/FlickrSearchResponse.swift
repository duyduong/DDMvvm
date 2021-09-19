//
//  FlickrSearchResponse.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

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

struct FlickrSearchResponse: Decodable {
  enum FlickrStatus: String, Decodable {
    case ok, fail
  }

  struct Photo: Hashable, Decodable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isPublic: Int
    var isFriend: Int
    var isFamily: Int

    var imageUrl: URL {
      let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
      return URL(string: url)!
    }

    private enum CodingKeys: String, CodingKey {
      case id, owner, secret, server, farm, title
      case isPublic = "ispublic"
      case isFriend = "isfriend"
      case isFamily = "isfamily"
    }
  }

  struct Photos: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [Photo]
  }

  var stat: FlickrStatus = .ok
  var photos: Photos
  var message: String?
}
