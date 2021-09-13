//
//  PageViewModel.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import RxCocoa
import RxSwift

protocol InternalPageViewModel {
  var pageLifeCycleRelay: PublishRelay<PageLifeCycle> { get }
}

public protocol IPageViewModel: IDestroyable {
  var pageLifeCycleChanged: Observable<PageLifeCycle> { get }
  var router: RouterType? { get set }
}

/// A master based ViewModel for all
open class PageViewModel: NSObject, IPageViewModel, InternalPageViewModel {
  let pageLifeCycleRelay = PublishRelay<PageLifeCycle>()
  public var pageLifeCycleChanged: Observable<PageLifeCycle> {
    pageLifeCycleRelay.asObservable()
  }
  public var router: RouterType?
  
  public override init() {
    super.init()
    self.initialize()
  }
  
  open func initialize() {}
  
  open func destroy() {
    disposeBag = DisposeBag()
  }
}
