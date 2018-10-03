//
//  DataTransformations.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

class IntToBoolTransform: TransformType {
    typealias Object = Bool
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? Int {
            return type != 0
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let value = value {
            return value ? 1 : 0
        }
        return nil
    }
}

class FlickrStatusTransform: TransformType {
    typealias Object = FlickrStatus
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let type = value as? String {
            return FlickrStatus(rawValue: type)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return value?.rawValue
    }
}


