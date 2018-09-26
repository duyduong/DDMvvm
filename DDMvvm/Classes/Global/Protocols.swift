//
//  Protocols.swift
//  phimbo
//
//  Created by Dao Duy Duong on 8/29/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol IDestroyable: class {
    
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

public protocol IView: IDestroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

// MARK: - Viewmodel protocols

public protocol IGenericViewModel: IDestroyable {
    
    associatedtype ModelElement
    
    var model: ModelElement? { get }
    
    func react()
}

public protocol IViewModel: IGenericViewModel {
    
    var viewState: BehaviorRelay<ViewState> { get }
    var showInlineLoader: BehaviorRelay<Bool> { get }
    
    var navigationService: INavigationService { get }
    
    init(model: ModelElement?, navigationService: INavigationService?)
}

public protocol IListViewModel: IViewModel {
    
    associatedtype CellViewModelElement: ICellViewModel
    
    var itemsSource: ReactiveCollection<CellViewModelElement> { get }
    var selectedItem: BehaviorRelay<CellViewModelElement?> { get }
    var selectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}

public protocol ICellViewModel: IGenericViewModel {
    
    init(model: ModelElement?)
}

















