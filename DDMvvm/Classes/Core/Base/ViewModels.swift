//
//  ViewModels.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol IReactable {
    var reactIfNeeded: Void { get }
}

extension Reactive where Base: IViewModel {
    
    public typealias ModelElement = Base.ModelElement
    
    public var model: Binder<ModelElement?> {
        return Binder(base) { $0.model = $1 }
    }
}

/// A master based ViewModel for all
open class ViewModel<M>: NSObject, IPageViewModel, IReactable {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    public var rxViewState = BehaviorRelay<ViewState>(value: .none)
    
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    var isReacted = false
    
    required public init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    /// Everytime model changed, this method will get called. Good place to update our viewModel
    open func modelChanged() {}
    
    /// This method will be called once. Good place to initialize our viewModel (listen, subscribe...) to any signals
    open func react() {}
    lazy var reactIfNeeded: Void = react()
}

/**
 A based ViewModel for ListPage.
 
 The idea for ListViewModel is that it will contain a list of CellViewModels
 By using this list, ListPage will render the cell and assign ViewModel to it respectively
 */
open class ListViewModel<M, S: Hashable, CVM: IViewModel>: ViewModel<M>, IListViewModel {
    
    public typealias SectionElement = S
    public typealias CellViewModelElement = CVM
    
    public let itemsSource = ItemSource<S, CVM>()
    public let rxSelectedItem = BehaviorRelay<CVM?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    required public init(model: M? = nil) {
        // Initially set empty first
        itemsSource.update { snapshot in
            snapshot.appendSections([])
        }
        super.init(model: model)
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
}

protocol IIndexable: class {
    var indexPath: IndexPath? { get set }
}

open class CellViewModel<M>: NSObject, IViewModel, IIndexable, IReactable {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    /// Each cell will keep its own index path
    /// In some cases, each cell needs to use this index to create some customizations
    public internal(set) var indexPath: IndexPath?
    
    /// Bag for databindings
    public var disposeBag: DisposeBag? = DisposeBag()
    
    var isReacted = false
    
    public required init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    /// Everytime model changed, this method will get called. Good place to update our viewModel
    open func modelChanged() {}
    
    /// This method will be called once. Good place to initialize our viewModel (listen, subscribe...) to any signals
    open func react() {}
    lazy var reactIfNeeded: Void = react()
}

/// A usefull CellViewModel based class to support ListPage and CollectionPage that have more than one cell identifier
open class SuperCellViewModel: CellViewModel<Any> {
    
    public required init(model: Any? = nil) {
        super.init(model: model)
    }
}














