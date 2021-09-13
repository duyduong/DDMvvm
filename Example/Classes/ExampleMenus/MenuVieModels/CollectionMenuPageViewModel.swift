//
//  CollectionMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum CollectionMenu: CaseIterable {
  case simple, advanced
}

extension CollectionMenu: Menu {
  var title: String {
    switch self {
    case .simple: return "Simple CollectionPage"
    case .advanced: return "CollectionPage with section"
    }
  }
  
  var description: String {
    switch self {
    case .simple: return "A simple CollectionPage which has one cell identifier."
    case .advanced: return "A simple CollectionPage with section header and multiple cell identifiers."
    }
  }
  
  func makePage() -> UIViewController? {
    switch self {
    case .simple: return SimpleCollectionPage(viewModel: SimpleListPageViewModel())
    case .advanced: return SectionCollectionPage(viewModel: SectionListPageViewModel())
    }
  }
}

class CollectionMenuPageViewModel: ExampleMenuPageViewModel<CollectionMenu> {
  override func prepareMenus() -> [CollectionMenu] {
    CollectionMenu.allCases
  }
}
