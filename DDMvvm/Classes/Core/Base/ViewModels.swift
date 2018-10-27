//
//  ViewModels.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import RxSwift
import RxCocoa

/// A master based ViewModel for all
open class ViewModel<M: Model>: NSObject, IViewModel {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            if _model != newValue {
                _model = newValue
                modelChanged()
            }
        }
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public let rxViewState = BehaviorRelay<ViewState>(value: .none)
    public let rxShowInlineLoader = BehaviorRelay(value: false)
    
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    required public init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    open func modelChanged() {}
    open func react() {}
}

/**
 A based ViewModel for ListPage. The idea for ListViewModel is that it will contain a list of CellViewModels
 By using this list, ListPage will render the cell and assign ViewModel to it respectively
 */
open class ListViewModel<M: Model, CVM: IGenericViewModel>: ViewModel<M>, IListViewModel where CVM.ModelElement: Model {
    
    public typealias CellViewModelElement = CVM
    
    public typealias ItemsSourceType = [SectionList<CVM>]
    
    public let itemsSource = ReactiveCollection<CVM>()
    public let rxSelectedItem = BehaviorRelay<CVM?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    required public init(model: M? = nil) {
        super.init(model: model)
    }
    
    open override func destroy() {
        super.destroy()
        
        itemsSource.forEach { (_, sectionList) in
            sectionList.forEach({ (_, cvm) in
                cvm.destroy()
            })
        }
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
}

/**
 A based ViewModel for TableCell and CollectionCell
 The difference between ViewModel and CellViewModel is that CellViewModel does not contain NavigationService
 */
open class CellViewModel<M: Model>: NSObject, IGenericViewModel {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            if _model != newValue {
                _model = newValue
                modelChanged()
            }
        }
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public required init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    open func react() {}
    open func modelChanged() {}
}

/// A usefull CellViewModel based class to support ListPage and CollectionPage that have more than one cell identifier
open class SuperCellViewModel: CellViewModel<Model> {
    
    required public init(model: Model? = nil) {
        super.init(model: model)
    }
}














