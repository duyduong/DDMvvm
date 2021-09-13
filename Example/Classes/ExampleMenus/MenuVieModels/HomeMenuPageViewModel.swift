//
//  HomeMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum HomeMenu: String, CaseIterable {
  case mvvm, dataBinding, serviceInjection, customTransition
}

extension HomeMenu: Menu {
  var title: String {
    switch self {
    case .mvvm:
      return "MVVM Examples"
    case .dataBinding:
      return "Data Binding Examples"
    case .serviceInjection:
      return "Service Injection Examples"
    case .customTransition:
      return "Transition Examples"
    }
  }
  
  var description: String {
    switch self {
    case .mvvm:
      return "Examples about different ways to use base classes Page, ListPage and CollectionPage."
    case .dataBinding:
      return "Examples about how to use data binding."
    case .serviceInjection:
      return "Examples about how to create a service and register it; how to inject to our ViewModel."
    case .customTransition:
      return "Examples about how to create a custom transitioning animation and apply it."
    }
  }
  
  func makePage() -> UIViewController? {
    switch self {
    case .mvvm: return ExampleMenuPage(viewModel: MvvmMenuPageViewModel(title: title))
    case .dataBinding: return ExampleMenuPage(viewModel: DataBindingMenuPageViewModel(title: title))
    case .serviceInjection: return nil
    case .customTransition: return ExampleMenuPage(viewModel: TransitionMenuPageViewModel(title: title))
    }
  }
}

class HomeMenuPageViewModel: ExampleMenuPageViewModel<HomeMenu> {
  override func prepareMenus() -> [HomeMenu] {
    HomeMenu.allCases
  }
}
