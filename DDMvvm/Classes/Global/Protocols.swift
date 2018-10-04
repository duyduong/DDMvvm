//
//  Protocols.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import RxSwift
import RxCocoa

public protocol IDestroyable: class {
    
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

public protocol ITransitionView: class {
    
    var animatorDelegate: AnimatorDelegate? { get set }
}

public protocol IAnyView: class {
    
    var anyViewModel: Any? { get set }
}

public protocol IView: IAnyView, IDestroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

// MARK: - Viewmodel protocols

public protocol IGenericViewModel: IDestroyable, Equatable {
    
    associatedtype ModelElement
    
    var model: ModelElement? { get set }
    
    init(model: ModelElement?)
    func react()
}

public protocol IViewModel: IGenericViewModel {
    
    var rxViewState: BehaviorRelay<ViewState> { get }
    var rxShowInlineLoader: BehaviorRelay<Bool> { get }
    
    var navigationService: INavigationService { get }
}

public protocol IListViewModel: IViewModel {
    
    associatedtype CellViewModelElement: IGenericViewModel
    
    var itemsSource: ReactiveCollection<CellViewModelElement> { get }
    var rxSelectedItem: BehaviorRelay<CellViewModelElement?> { get }
    var rxSelectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}


















