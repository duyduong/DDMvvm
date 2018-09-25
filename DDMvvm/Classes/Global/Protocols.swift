//
//  Protocols.swift
//  phimbo
//
//  Created by Dao Duy Duong on 8/29/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import RxSwift

public protocol Destroyable: class {
    
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

public protocol GenericView: Destroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

// MARK: - Viewmodel protocols

public protocol IViewModel: Destroyable {
    
    associatedtype ModelElement
    
    var model: ModelElement? { get }
    
    func react()
}

public protocol GenericViewModel: IViewModel {
    
    var varViewState: Variable<ViewState> { get }
    var varLoading: Variable<Bool> { get }
    
    var navigationService: INavigationService { get }
    
    init(model: ModelElement?, navigationService: INavigationService?)
}

public protocol GenericListViewModel: GenericViewModel {
    
    associatedtype CellViewModelElement: GenericCellViewModel
    
    var itemsSource: SectionList<CellViewModelElement> { get }
    var varSelectedItem: Variable<CellViewModelElement?> { get }
    var varSelectedIndex: Variable<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}

public protocol GenericCellViewModel: IViewModel {
    
    init(model: ModelElement?)
}

















