//
//  JsonService.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import RxSwift
import DDMvvm

// MARK: - Json service, service for calling API

protocol IJsonService {
    
    func request<T: Mappable>(_ path: String,
                              method: HTTPMethod,
                              params: [String: Any]?,
                              parameterEncoding encoding: ParameterEncoding,
                              additionalHeaders: HTTPHeaders?) -> Single<T>
    
    func request<T: Mappable>(_ path: String,
                              method: HTTPMethod,
                              params: [String: Any]?,
                              parameterEncoding encoding: ParameterEncoding,
                              additionalHeaders: HTTPHeaders?) -> Single<[T]>
}

extension IJsonService {
    
    func request<T: Mappable>(_ path: String,
                                     method: HTTPMethod,
                                     params: [String: Any]? = nil,
                                     parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                     additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: method, params: params, parameterEncoding: encoding, additionalHeaders: additionalHeaders)
    }
    
    func request<T: Mappable>(_ path: String,
                                     method: HTTPMethod,
                                     params: [String: Any]? = nil,
                                     parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                     additionalHeaders: HTTPHeaders? = nil) -> Single<[T]> {
        return request(path, method: method, params: params, parameterEncoding: encoding, additionalHeaders: additionalHeaders)
    }
}

extension IJsonService {
    
    func get<T: Mappable>(_ path: String,
                                 params: [String: Any]? = nil,
                                 parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                 additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: .get, params: params, additionalHeaders: additionalHeaders)
    }
    
    func get<T: Mappable>(_ path: String,
                                 params: [String: Any]? = nil,
                                 parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                 additionalHeaders: HTTPHeaders? = nil) -> Single<[T]> {
        return request(path, method: .get, params: params, additionalHeaders: additionalHeaders)
    }
    
    func post<T: Mappable>(_ path: String,
                                  params: [String: Any]? = nil,
                                  parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                  additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: .post, params: params, additionalHeaders: additionalHeaders)
    }
    
    func post<T: Mappable>(_ path: String,
                                  params: [String: Any]? = nil,
                                  parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                  additionalHeaders: HTTPHeaders? = nil) -> Single<[T]> {
        return request(path, method: .post, params: params, additionalHeaders: additionalHeaders)
    }
}

/// Json API service
open class JsonService: NetworkService, IJsonService {
    
    func request<T: Mappable>(_ path: String,
                                     method: HTTPMethod,
                                     params: [String: Any]? = nil,
                                     parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                     additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return callRequest(path, method: method, params: params, parameterEncoding: encoding, additionalHeaders: additionalHeaders)
            .map { responseString in
                if let model = Mapper<T>().map(JSONString: responseString) {
                    return model
                }
                
                throw NSError(domain: "com.example.error", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Cannot mapp JSON to Model"])
        }
    }
    
    func request<T: Mappable>(_ path: String,
                                     method: HTTPMethod, params: [String: Any]? = nil,
                                     parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                                     additionalHeaders: HTTPHeaders? = nil) -> Single<[T]> {
        return callRequest(path, method: method, params: params, parameterEncoding: encoding, additionalHeaders: additionalHeaders)
            .map { responseString in
                if let models = Mapper<T>().mapArray(JSONString: responseString) {
                    return models
                }
                
                throw NSError(domain: "com.example.error", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Cannot mapp JSON to Model"])
        }
    }
}
