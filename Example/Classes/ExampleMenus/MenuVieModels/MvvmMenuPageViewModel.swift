//
//  MvvmMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum MvvmMenu: String, CaseIterable {
  case list, collection, advanced1, advanced2
}

extension MvvmMenu: Menu {
  var title: String {
    switch self {
    case .list: return "ListPage Examples"
    case .collection: return "CollectionPage Examples"
    case .advanced1: return "Advanced Example 1"
    case .advanced2: return "Advanced Example 2"
    }
  }
  
  var description: String {
    switch self {
    case .list: return "Demostration on how to use ListPage"
    case .collection: return "Demostration on how to use CollectionPage"
    case .advanced1: return "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"
    case .advanced2: return "An advanced example on using Search Bar to search images on Flickr."
    }
  }
  
  func makePage() -> UIViewController? {
    switch self {
    case .list: return ExampleMenuPage(viewModel: ListMenuPageViewModel(title: title))
    case .collection: return ExampleMenuPage(viewModel: CollectionMenuPageViewModel(title: title))
    case .advanced1: return ContactListPage(viewModel: ContactListPageViewModel())
    case .advanced2: return FlickrSearchPage(viewModel: FlickrSearchPageViewModel())
    }
  }
}

class MvvmMenuPageViewModel: ExampleMenuPageViewModel<MvvmMenu> {
  override func prepareMenus() -> [MvvmMenu] {
    MvvmMenu.allCases
  }
}
