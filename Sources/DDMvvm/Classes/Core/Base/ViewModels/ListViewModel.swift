//
//  ListViewModel.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import RxCocoa
import RxSwift

protocol IntenalListViewModel {
  var selectedIndexRelay: PublishRelay<IndexPath> { get }
}

public protocol IListViewModel: IPageViewModel {
  associatedtype Section: Hashable
  associatedtype Item: Hashable
  typealias SelectedItem = (indexPath: IndexPath, item: Item?)

  var itemsSource: ItemSource<Section, Item> { get }
  var selectedItemChanged: Observable<SelectedItem> { get }

  func selectedItemDidChange(_ cellViewModel: Item)
}

open class ListViewModel<Section: Hashable, Item: Hashable>: PageViewModel, IListViewModel {
  public let itemsSource = ItemSource<Section, Item>()

  let selectedIndexRelay = PublishRelay<IndexPath>()
  public var selectedItemChanged: Observable<SelectedItem> {
    selectedIndexRelay.map { [weak self] indexPath in
      guard let self = self else {
        return (indexPath, nil)
      }

      return (indexPath, self.itemsSource[indexPath: indexPath])
    }
  }

  open func selectedItemDidChange(_ cellViewModel: Item) {}
}
