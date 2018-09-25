//
//  DependencyManager.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 4/3/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation

typealias RegistrationBlock = (() -> Any)
public typealias GenericRegistrationBlock<T> = (() -> T)

protocol IMutableDependencyResolver {
    func getService(_ type: Any) -> Any?
    func registerService(_ factory: @escaping RegistrationBlock, type: Any)
}

extension IMutableDependencyResolver {
    
    func getService<T>() -> T {
        return getService(T.self) as! T
    }
    
    func registerService<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        return registerService({ factory() }, type: T.self)
    }
    
}

class DefaultDependencyResolver: IMutableDependencyResolver {
    
    private var registry = [String: RegistrationBlock]()
    
    func getService(_ type: Any) -> Any? {
        let k = String(describing: type)
        for key in registry.keys {
            if k.contains(key) {
                return registry[key]?()
            }
        }
        return nil
    }
    
    func registerService(_ factory: @escaping RegistrationBlock, type: Any) {
        let k = String(describing: type)
        registry[k] = factory
    }

}

public class DependencyManager {
    
    public static let shared: DependencyManager = DependencyManager()
    
    private let resolver: IMutableDependencyResolver = DefaultDependencyResolver()
    
    public func registerDefaults() {
        registerService { () -> INavigationService in NavigationService() }
        registerService { () -> IStorageService in StorageService() }
        registerService { () -> IAlertService in AlertService() }
    }
    
    public func registerUnitTestDefaults() {
        
    }
    
    public func getService<T>() -> T {
        return resolver.getService()
    }
    
    public func registerService<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        resolver.registerService(factory)
    }
    
}




