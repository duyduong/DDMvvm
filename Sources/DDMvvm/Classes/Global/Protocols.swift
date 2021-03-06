//
//  Protocols.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

/// Destroyable type for handling dispose bag and destroy it
public protocol IDestroyable: class {
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

public extension IDestroyable {
    func destroy() {
        disposeBag = DisposeBag()
    }
}

/// PopView type for Page to implement as a pop view
public protocol IPopupView where Self: UIViewController {
    
    /*
     Setup popup layout
     
     Popview is a UIViewController base, therefore it already has a filled view in. This method allows
     implementation to layout it customly. For example:
     
     ```
     view.cornerRadius = 7
     view.autoCenterInSuperview()
     ```
     */
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

/// TransitionView type to create custom transitioning between pages
public protocol ITransitionView where Self: UIViewController {
    
    /**
     Keep track of animator delegate for custom transitioning
     */
    var animatorDelegate: AnimatorDelegate? { get set }
}

/// AnyView type for helping assign any viewModel to any view
public protocol IAnyView: class {
    
    /**
     Any value assign to this property will be delegate to its correct viewModel type
     */
    var anyViewModel: Any? { get set }
}

/// Base View type for the whole library
public protocol IView: IAnyView, IDestroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

extension IView {
    
    func viewModelChanged() {
        cleanBags()
        (viewModel as? IReactable)?.react()
        bindViewAndViewModel()
    }
    
    func cleanBags() {
        disposeBag = DisposeBag()
        (viewModel as? IDestroyable)?.disposeBag = DisposeBag()
    }
}

// MARK: - Viewmodel protocols

/// Base ViewModel type for Page (UIViewController), View (UIVIew)
public protocol IViewModel: IDestroyable, Hashable {
    associatedtype ModelElement
    
    var model: ModelElement? { get set }
    
    init(model: ModelElement?)
}

public protocol IPageViewModel: IViewModel {
    var rxViewState: BehaviorRelay<ViewState> { get }
}

// MARK: - ListViewModel

public struct ItemSource<S: Hashable, CVM: IViewModel> {
    
    /// Snapshot data wraper
    public struct Snapshot {
        public let snapshot: DiffableDataSourceSnapshot<S, CVM>
        public let animated: Bool
    }
    
    let rxSnapshot = BehaviorRelay<Snapshot?>(value: nil)
    
    /// Current snapshot
    public var snapshot: DiffableDataSourceSnapshot<S, CVM>? { rxSnapshot.value?.snapshot }
    
    /// Snapshot change observable
    public var snapshotChanged: Observable<Snapshot?> { rxSnapshot.asObservable() }
    
    /// Update itemsSource with new snapshot
    public func update(animated: Bool = false, block: ((inout DiffableDataSourceSnapshot<S, CVM>) -> Void)) {
        var snapshot = self.snapshot ?? DiffableDataSourceSnapshot<S, CVM>()
        block(&snapshot)
        rxSnapshot.accept(Snapshot(snapshot: snapshot, animated: animated))
    }
}

public protocol IListViewModel: IPageViewModel {
    
    associatedtype SectionElement: Hashable
    associatedtype CellElement: IViewModel
    
    var itemsSource: ItemSource<SectionElement, CellElement> { get }
    var rxSelectedItem: BehaviorRelay<CellElement?> { get }
    var rxSelectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellElement)
}


















