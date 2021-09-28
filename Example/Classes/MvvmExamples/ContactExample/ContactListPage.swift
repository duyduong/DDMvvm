//
//  ContactListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit
import RxSwift

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
  typealias Route = ContactListRoute
  
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
      self?.updateContact(nil)
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
    updateContact(item)
  }
  
  private func updateContact(_ contact: Contact?) {
    let contactEditPageViewModel = ContactEditPageViewModel(contact: contact)
    viewModel.observeContactChanged(viewModel: contactEditPageViewModel)
    route(to: .contactForm(viewModel: contactEditPageViewModel))
  }
}

/// Example to override default routable implementation
extension ContactListPage: Routable {
  func route(to route: ContactListRoute) {
    guard let page = route.makePage() else { return }
    navigationController?.present(page, animated: true, completion: nil)
  }
}

class ContactListPageViewModel: ListViewModel<SingleSection, Contact> {
  private var updateBag = DisposeBag()

  fileprivate func observeContactChanged(viewModel: ContactEditPageViewModel) {
    updateBag = DisposeBag()

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
    }) => updateBag
  }
}
