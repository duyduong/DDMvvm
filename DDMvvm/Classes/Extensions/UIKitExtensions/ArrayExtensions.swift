//
//  ArrayExtensions.swift
//  Snapshot
//
//  Created by Lữ on 4/16/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation

extension Array {
    
    public func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Array where Element: Model {
    
    public func toCellViewModels<T: ICellViewModel>() -> [T] where T.ModelElement == Element {
        return self.flatMap { [T(model: $0)] }
    }
}
