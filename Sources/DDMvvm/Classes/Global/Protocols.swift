//
//  Protocols.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

/// AnyView type for helping assign any viewModel to any view
public protocol IAnyView: AnyObject {
  
  /**
   Any value assign to this property will be delegate to its correct viewModel type
   */
  var anyViewModel: Any? { get set }
}

/// Base View type for the whole library
public protocol IView: IAnyView, IDestroyable {
  
  associatedtype ViewModelElement: IDestroyable
  
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
    viewModel?.disposeBag = DisposeBag()
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


















