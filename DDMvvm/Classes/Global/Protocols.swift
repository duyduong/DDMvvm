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

public protocol IPopupView: class {
    
    /// Layout this view inside the presenter page
    func popupLayout()
    
    /*
     Show animation
     
     The presenter page has overlayView, use this if we want to animation the overlayView too, e.g alpha
     */
    func show(overlayView: UIView)
    
    /*
     Hide animation
     
     Must call completion when the animation is finished
     */
    func hide(overlayView: UIView, completion: @escaping (() -> ()))
}

public protocol ITransitionView: class {
    
    /**
     Keep track of animator delegate for custom transitioning
     */
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
    func viewModelChanged()
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
    
    var rxShowLocalHud: BehaviorRelay<Bool> { get }
    
    @available(*, deprecated, renamed: "rxShowLocalHud")
    var rxShowInlineLoader: BehaviorRelay<Bool> { get }
    
    var navigationService: INavigationService { get }
}

public protocol IndexableCellViewModel: class {
    
    var indexPath: IndexPath? { get }
    func setIndexPath(_ indexPath: IndexPath?)
}

internal protocol MutableIndexableCellViewModel: IndexableCellViewModel {
    
    var indexPath: IndexPath? { get set }
}

extension MutableIndexableCellViewModel {
    
    public func setIndexPath(_ indexPath: IndexPath?) {
        self.indexPath = indexPath
    }
}

public protocol ICellViewModel: IGenericViewModel {
    
    var requestUpdateObservable: Observable<IndexPath?> { get }
    func requestUpdate()
}

public protocol IListViewModel: IViewModel {
    
    associatedtype CellViewModelElement: ICellViewModel
    
    var itemsSource: ReactiveCollection<CellViewModelElement> { get }
    var rxSelectedItem: BehaviorRelay<CellViewModelElement?> { get }
    var rxSelectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}


















