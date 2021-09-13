//
//  ListMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum ListMenu: CaseIterable {
  case simple, advanced
}

extension ListMenu: Menu {
  var title: String {
    switch self {
    case .simple: return "Simple ListPage"
    case .advanced: return "ListPage with section"
    }
  }
  
  var description: String {
    switch self {
    case .simple: return "A simple ListPage which has one cell identifier."
    case .advanced: return "A simple ListPage with section header and multiple cell identifiers."
    }
  }
  
  func makePage() -> UIViewController? {
    switch self {
    case .simple: return SimpleListPage(viewModel: SimpleListPageViewModel())
    case .advanced: return SectionListPage(viewModel: SectionListPageViewModel())
    }
  }
}

class ListMenuPageViewModel: ExampleMenuPageViewModel<ListMenu> {
  override func prepareMenus() -> [ListMenu] {
    ListMenu.allCases
  }
}
