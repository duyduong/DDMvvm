//
//  Model.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import ObjectMapper

open class Model: NSObject, Mappable {
    
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {}
}

extension Model {
    
    static func fromJSON<T: Mappable>(_ JSON: Any?) -> T? {
        return Mapper<T>().map(JSONObject: JSON)
    }
    
    static func fromJSONArray<T: Mappable>(_ JSON: Any?) -> [T] {
        return Mapper<T>().mapArray(JSONObject: JSON) ?? []
    }
}







