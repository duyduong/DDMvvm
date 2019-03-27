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
    
    func remove(_ key: String)
}

public class StorageService: IStorageService {
    
    private let defaults = UserDefaults.standard
    
    public func save<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    public func saveModel<T: Model>(_ model: T?, forKey key: String) {
        if let model = model {
            let json = model.toJSON()
            defaults.set(json, forKey: key)
            defaults.synchronize()
        }
    }
    
    public func loadModel<T: Model>(forKey key: String) -> T? {
        if let json = defaults.object(forKey: key) {
            return Model.fromJSON(json)
        }
        
        return nil
    }
    
    public func saveModels<T: Model>(_ models: [T]?, forKey key: String) {
        if let models = models {
            let json = models.toJSON()
            defaults.set(json, forKey: key)
            defaults.synchronize()
        }
    }
    
    public func loadModels<T: Model>(forKey key: String) -> [T]? {
        if let json = defaults.object(forKey: key) {
            return Model.fromJSONArray(json)
        }
        
        return nil
    }
    
    public func remove(_ key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}

















