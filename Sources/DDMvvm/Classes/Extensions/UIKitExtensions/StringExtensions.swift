//
//  StringExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public extension String {
  func asURL() -> URL? {
    URL(string: self)
  }

  func asURLRequest() -> URLRequest? {
    if let url = asURL() {
      return URLRequest(url: url)
    }
    return nil
  }

  func toHex() -> Int? {
    Int(self, radix: 16)
  }

  func trim() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
