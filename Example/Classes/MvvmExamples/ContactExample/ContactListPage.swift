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
    ContactCell.identifier
  }

  override func selectedItemDidChange(_ item: Contact) {
    guard let indexPath = viewModel.itemsSource[item: item] else {
      return
    }
    tableView.deselectRow(at: indexPath, animated: true)
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
    viewModel.contactUpdateObservable.subscribe(onNext: { [weak self] updatedContact in
      guard let self = self else { return }
      self.itemsSource.update(animated: true) { snapshot in
        var newSnapshot = DataSourceSnapshot()
        newSnapshot.appendSections([.main])
        var items = snapshot.itemIdentifiers
        if let index = items.firstIndex(where: { $0.id == updatedContact.id }) {
          items[index] = updatedContact
        } else {
          items.append(updatedContact)
        }
        newSnapshot.appendItems(items)
        snapshot = newSnapshot
      }
    }) => disposeBag

    router?.route(
      to: ContactListRoute.contactForm(viewModel: viewModel),
      transition: .popup
    )
  }
}
