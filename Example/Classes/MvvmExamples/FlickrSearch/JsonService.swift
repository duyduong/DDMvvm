//
//  JsonService.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import DDMvvm

// MARK: - Json service, service for calling API

protocol IJsonService {
    
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any]?,
        parameterEncoding encoding: ParameterEncoding,
        additionalHeaders: HTTPHeaders?
    ) -> Single<T>
}

extension IJsonService {
    
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any]? = nil,
        parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
        additionalHeaders: HTTPHeaders? = nil
    ) -> Single<T> {
        return request(path: path, method: method, params: params, parameterEncoding: encoding, additionalHeaders: additionalHeaders)
    }
}

extension IJsonService {
    
    func get<T: Decodable>(
        path: String,
        params: [String: Any]? = nil,
        parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
        additionalHeaders: HTTPHeaders? = nil
    ) -> Single<T> {
        return request(path: path, method: .get, params: params, additionalHeaders: additionalHeaders)
    }
    
    func post<T: Decodable>(
        path: String,
        params: [String: Any]? = nil,
        parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
        additionalHeaders: HTTPHeaders? = nil
    ) -> Single<T> {
        return request(path: path, method: .post, params: params, additionalHeaders: additionalHeaders)
    }
}

/// Json API service
class JsonService: IJsonService {
    
    let sessionManager: Session
    private let sessionConfiguration: URLSessionConfiguration = .default
    
    var timeout: TimeInterval = 30 {
        didSet { sessionConfiguration.timeoutIntervalForRequest = timeout }
    }
    
    private let baseUrl: String
    var defaultHeaders = HTTPHeaders()
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        
        sessionConfiguration.timeoutIntervalForRequest = timeout
        sessionManager = Session(configuration: sessionConfiguration)
    }
    
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: Any]? = nil,
        parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
        additionalHeaders: HTTPHeaders? = nil
    ) -> Single<T> {
        let obs: Single<Data> = Single.create { single in
            let headers = self.makeHeaders(additionalHeaders)
            let request = self.sessionManager.request(
                "\(self.baseUrl)/\(path)",
                method: method,
                parameters: params,
                encoding: encoding,
                headers: headers)
            
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create { request.cancel() }
        }
        
        return obs.map { (data: Data) -> T in
            try JSONDecoder().decode(T.self, from: data)
        }
    }
    
    private func makeHeaders(_ additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = defaultHeaders
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { headers.add($0) }
        }
        
        return headers
    }
}
