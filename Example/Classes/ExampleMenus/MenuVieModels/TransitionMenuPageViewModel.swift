//
//  TransitionMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum TransitionMenu: CaseIterable {
  case inNavigation, inModal
}

extension TransitionMenu: Menu {
  var title: String {
    switch self {
    case .inNavigation: return "Transition in NavigationPage"
    case .inModal: return "Transition using modal presentation"
    }
  }
  
  var description: String { "" }
  
  func makePage() -> UIViewController? {
    NavigationTransitionExamplePage(
      viewModel: NavigationTransitionExamplePageViewModel(menu: self)
    )
  }
}

class TransitionMenuPageViewModel: ExampleMenuPageViewModel<TransitionMenu> {
  override func prepareMenus() -> [TransitionMenu] {
    TransitionMenu.allCases
  }
}
