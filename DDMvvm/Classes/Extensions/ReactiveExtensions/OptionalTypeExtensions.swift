//
//  OptionalType.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public protocol OptionalType {
    
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where Element: OptionalType {
    
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            return Observable.from(optional: element.value)
        }
    }
    
}
