//
//  Requester.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
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
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Configs.requestTimeout
        
        sessionManager = Alamofire.SessionManager(configuration: config)
    }
    
    public func callRequest(_ url: String, _ method: HTTPMethod, params: [String: Any]? = nil, additionalHeaders: HTTPHeaders? = nil) -> Observable<String> {
        return Observable.create { observer in
            let headers = self.makeHeaders(additionalHeaders)
            let request = self.sessionManager.request(
                url,
                method: method,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers)
            
            request.responseString { response in
                if let error = response.result.error {
                    observer.onError(error)
                } else if let body = response.result.value {
                    observer.onNext(body)
                } else {
                    observer.onError(NSError.unknown)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    private func makeHeaders(_ additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers: HTTPHeaders = [String: String]()
        switch Configs.httpContentType {
        case .json:
            headers["Content-Type"] = "application/json"
        default:
            headers["Content-Type"] = "text/xml"
        }
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { pair in
                headers.updateValue(pair.value, forKey: pair.key)
            }
        }
        
        return headers
    }
    
}

public class JsonService: NetworkService {
    
    
    
}
