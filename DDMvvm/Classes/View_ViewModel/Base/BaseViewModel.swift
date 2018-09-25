//
//  ViewModel.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Base view model

open class ViewModel<M: Model>: NSObject, GenericViewModel {
    
    public typealias ModelElement = M
    
    public var model: M?
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public let viewState = BehaviorRelay<ViewState>(value: .none)
    public let showInlineLoader = BehaviorRelay(value: false)
    
    public let navigationService: INavigationService
    
    required public init(model: M? = nil, navigationService: INavigationService? = nil) {
        self.model = model
        self.navigationService = navigationService ?? DependencyManager.shared.getService()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    open func react() {}
}

// MARK: - list viewmodel, support multiple sections

open class ListViewModel<M: Model, CVM: GenericCellViewModel>: ViewModel<M>, GenericListViewModel where CVM.ModelElement: Model {
    
    public typealias CellViewModelElement = CVM
    
    public typealias ItemsSourceType = [[CVM]]
    
    public let itemsSource = ReactiveCollection<CVM>()
    public let selectedItem = BehaviorRelay<CVM?>(value: nil)
    public let selectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    required public init(model: M? = nil, navigationService: INavigationService? = nil) {
        super.init(model: model)
    }
    
    // MARK: - Sources manipulating
    
    public func makeSources(_ items: [[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { sections in
            let cvms = sections.toCellViewModels() as [CVM]
            return cvms
        }
    }
    
    public func makeSources(_ items: [CVM.ModelElement]) -> ItemsSourceType {
        let cvms = items.toCellViewModels() as [CVM]
        return [cvms]
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
}

// MARK: - Cell viewmodel

open class CellViewModel<M: Model>: GenericCellViewModel {
    
    public typealias ModelElement = M
    
    public var model: M?
    public var disposeBag: DisposeBag? = DisposeBag()
    
    required public init(model: M? = nil) {
        self.model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    open func react() {}
}

open class SuperCellViewModel: CellViewModel<Model> {
    
    required public init(model: Model? = nil) {
        super.init(model: model)
    }
}














