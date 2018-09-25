//
//  StringExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func toURLRequest() -> URLRequest? {
        if let url = toURL() {
            return URLRequest(url: url)
        }
        return nil
    }
    
    func toHex() -> Int? {
        return Int(self, radix: 16)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}




