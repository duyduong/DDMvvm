//
//  ArrayExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation

extension Array {
    
    /// Chunk array into smaller parts
    public func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Array where Element: Model {
    
    /// Transform array of models into array of viewmodels
    public func toCellViewModels<T: IGenericViewModel>() -> [T] where T.ModelElement == Element {
        return compactMap { T(model: $0) }
    }
}
