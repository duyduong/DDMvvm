//
//  StorageService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

public protocol IStorageService {
    
    func save<T>(_ value: T, forKey key: String)
    func get<T>(forKey key: String) -> T?
    
    func saveModel<T: Model>(_ model: T?, forKey key: String)
    func loadModel<T: Model>(forKey key: String) -> T?
    
    func saveModels<T: Model>(_ models: [T]?, forKey key: String)
    func loadModels<T: Model>(forKey key: String) -> [T]?
}

public class StorageService: IStorageService {
    
    private let defaults = UserDefaults.standard
    
    public func save<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    public func saveModel<T: Model>(_ model: T?, forKey key: String) {
        if let model = model {
            let json = Mapper<T>().toJSON(model)
            defaults.set(json, forKey: key)
        }
    }
    
    public func loadModel<T: Model>(forKey key: String) -> T? {
        if let json = defaults.object(forKey: key) {
            return Mapper<T>().map(JSONObject: json)
        }
        
        return nil
    }
    
    public func saveModels<T: Model>(_ models: [T]?, forKey key: String) {
        if let models = models {
            let json = Mapper<T>().toJSONArray(models)
            defaults.set(json, forKey: key)
        }
    }
    
    public func loadModels<T: Model>(forKey key: String) -> [T]? {
        if let json = defaults.object(forKey: key) {
            return Mapper<T>().mapArray(JSONObject: json)
        }
        
        return nil
    }
}

















