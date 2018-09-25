//
//  OptionalType.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol OptionalType {
    
    associatedtype Wrapped
    var value: Wrapped? { get }
    
}

extension Optional: OptionalType {
    
    var value: Wrapped? {
        return self
    }
    
}

extension ObservableType where E: OptionalType {
    
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            return Observable.from(optional: element.value)
        }
    }
    
}
