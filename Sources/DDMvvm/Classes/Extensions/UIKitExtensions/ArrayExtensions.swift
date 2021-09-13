//
//  ArrayExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation

public extension Array {
  /// Chunk array into smaller parts
  func chunked(by chunkSize: Int) -> [[Element]] {
    stride(from: 0, to: count, by: chunkSize).map {
      Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
    }
  }
}

public extension Array {
  subscript(safe index: Int) -> Element? {
    index >= 0 && index < count ? self[index] : nil
  }
}
