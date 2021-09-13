//
//  DataBindingMenuPageViewModel.swift
//  Example
//
//  Created by Dao Duy Duong on 12/09/2021.
//

import UIKit

enum DataBindingMenu: String, CaseIterable {
  case binding, custom
}

extension DataBindingMenu: Menu {
  var title: String {
    switch self {
    case .binding: return "One-way, Two-way and Action Binding"
    case .custom: return "Custom Control with Data Binding"
    }
  }
  
  var description: String {
    switch self {
    case .binding: return "How to setup data binding between ViewModel and View"
    case .custom: return "How to create a control with two-way binding property."
    }
  }
  
  func makePage() -> UIViewController? {
    switch self {
    case .binding:
      return DataBindingExamplePage(
        viewModel: DataBindingExamplePageViewModel(menu: self)
      )

    case .custom:
      return CustomControlExamplePage(
        viewModel: CustomControlExamplePageViewModel(menu: self)
      )
    }
  }
}

class DataBindingMenuPageViewModel: ExampleMenuPageViewModel<DataBindingMenu> {
  override func prepareMenus() -> [DataBindingMenu] {
    DataBindingMenu.allCases
  }
}
