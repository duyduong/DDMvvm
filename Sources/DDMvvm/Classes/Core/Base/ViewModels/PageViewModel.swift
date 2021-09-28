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
}

/// The  based ViewModel for `Page`
open class PageViewModel: IPageViewModel, InternalPageViewModel {
  let pageLifeCycleRelay = PublishRelay<PageLifeCycle>()
  public var pageLifeCycleChanged: Observable<PageLifeCycle> {
    pageLifeCycleRelay.asObservable()
  }

  public init() {
    initialize()
  }

  open func initialize() {}
}
