//
//  ContactListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

enum ContactListRoute: RouteType {
  case contactForm(viewModel: ContactEditPageViewModel)
  
  func makePage() -> UIViewController? {
    switch self {
    case let .contactForm(viewModel):
      return WrapperPage(rootViewController: ContactEditPage(viewModel: viewModel))
    }
  }
}

class ContactListPage: ListPage<ContactListPageViewModel> {

  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  override func initialize() {
    // By default, tableView will pin to 4 edges of superview
    // If you want to layout tableView differently, then remove this line
    super.initialize()

    title = "Contact List"

    navigationItem.rightBarButtonItem = addBtn

    tableView.estimatedRowHeight = 150
    tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
  }

  override func bindViewAndViewModel() {
    super.bindViewAndViewModel()

    addBtn.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.viewModel.addContact()
    }) => disposeBag
  }

  override func cellIdentifier(_ item: Contact) -> String {
    return ContactCell.identifier
  }

  override func selectedItemDidChange(_ item: Contact) {
//    if let indexPath = viewModel?.rxSelectedIndex.value {
//      tableView.deselectRow(at: indexPath, animated: true)
//    }
  }
}

class ContactListPageViewModel: ListViewModel<SingleSection, Contact> {
  override func selectedItemDidChange(_ item: Contact) {
    handleContactModification(item)
  }

  fileprivate func addContact() {
    handleContactModification()
  }

  private func handleContactModification(_ contact: Contact? = nil) {
    let viewModel = ContactEditPageViewModel(contact: contact)

    // as you are controlling the ViewModel of edit page,
    // so we can get the result out without using any Delegates
    viewModel.contactObservable.subscribe(onNext: { [weak self] updatedContact in
      guard let self = self else { return }
      self.itemsSource.update(animated: true) { snapshot in
        if snapshot.numberOfSections == 0 {
          snapshot.appendSections([.main])
        }
        if snapshot.itemIdentifiers.contains(updatedContact) {
          snapshot.reloadItems([updatedContact])
        } else {
          snapshot.appendItems([updatedContact])
        }
      }
    }) => disposeBag
    router?.route(
      to: ContactListRoute.contactForm(viewModel: viewModel),
      transition: .init(type: .popup)
    )
  }
}
