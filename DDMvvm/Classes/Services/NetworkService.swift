//
//  NetworkService.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

open class NetworkService {
    
    let sessionManager: SessionManager
    private let sessionConfiguration: URLSessionConfiguration = .default
    
    public var timeout: TimeInterval = 30 {
        didSet { sessionConfiguration.timeoutIntervalForRequest = timeout }
    }
    
    let baseUrl: String
    var defaultHeaders: HTTPHeaders = [:]
    
    public init(baseUrl: String) {
        assert(baseUrl.isEmpty, "baseUrl should not be empty.")
        self.baseUrl = baseUrl
        
        sessionConfiguration.timeoutIntervalForRequest = timeout
        sessionManager = Alamofire.SessionManager(configuration: sessionConfiguration)
    }
    
    public func callRequest(_ path: String, method: HTTPMethod, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Single<String> {
        return Single.create { single in
            let headers = self.makeHeaders(additionalHeaders)
            let request = self.sessionManager.request(
                "\(self.baseUrl)/\(path)",
                method: method,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers)
            
            request.responseString { response in
                if let error = response.result.error {
                    single(.error(error))
                } else if let body = response.result.value {
                    single(.success(body))
                } else {
                    single(.error(NSError.unknown))
                }
            }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    private func makeHeaders(_ additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = defaultHeaders
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { pair in
                headers.updateValue(pair.value, forKey: pair.key)
            }
        }
        
        return headers
    }
}

public protocol IJsonService {
    
    func request<T: Mappable>(_ path: String, method: HTTPMethod, params: [String: Any]?, additionalHeaders: HTTPHeaders?) -> Single<T>
}

extension IJsonService {
    
    public func request<T: Mappable>(_ path: String, method: HTTPMethod, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: method, params: params, additionalHeaders: additionalHeaders)
    }
}

/// Extensions for JsonService
extension IJsonService {
    
    public func get<T: Mappable>(_ path: String, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: .get, params: params, additionalHeaders: additionalHeaders)
    }
    
    public func post<T: Mappable>(_ path: String, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return request(path, method: .post, params: params, additionalHeaders: additionalHeaders)
    }
}

public class JsonService: NetworkService, IJsonService {
    
    public override init(baseUrl: String) {
        super.init(baseUrl: baseUrl)
        
        defaultHeaders["Content-Type"] = "application/json"
    }
    
    public func request<T: Mappable>(_ path: String, method: HTTPMethod, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Single<T> {
        return callRequest(path, method: method, params: params, additionalHeaders: additionalHeaders)
            .map { responseString in
                if let model = Mapper<T>().map(JSONString: responseString) {
                    return model
                }
                
                throw NSError.mappingError
            }
    }
}

public class XmlService: NetworkService {
    
    public override init(baseUrl: String) {
        super.init(baseUrl: baseUrl)
        
        defaultHeaders["Content-Type"] = "text/xml"
    }
}
