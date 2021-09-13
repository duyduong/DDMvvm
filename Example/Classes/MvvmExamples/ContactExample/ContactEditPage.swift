//
//  ContactEditPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import RxSwift
import UIKit

class WrapperPage: NavigationPage, IPopupView {
  var layout: PopupLayout {
    .center(width: .pinEdge(insets: 24), height: .pinEdge(insets: 24))
  }
}

class ContactEditPage: Page<ContactEditPageViewModel> {
  let scrollView = ScrollableStackView()
  let containerView = UIView()

  let nameTxt = UITextField()
  let phoneTxt = UITextField()
  let submitBtn = UIButton(type: .custom)
  let cancelBtn = UIButton(type: .custom)

  override func initialize() {
    title = "Add/Edit Contact"

    enableBackButton = true

    nameTxt.borderStyle = .roundedRect
    nameTxt.placeholder = "Enter your name"

    phoneTxt.borderStyle = .roundedRect
    phoneTxt.placeholder = "Enter your phone number"

    cancelBtn.setTitle("Cancel", for: .normal)
    cancelBtn.setTitleColor(.white, for: .normal)
    cancelBtn.setBackgroundImage(UIImage.from(color: .red), for: .normal)
    cancelBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
    cancelBtn.cornerRadius = 5

    submitBtn.setTitle("Save", for: .normal)
    submitBtn.setTitleColor(.white, for: .normal)
    submitBtn.setTitleColor(.lightGray, for: .disabled)
    submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
    submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
    submitBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
    submitBtn.cornerRadius = 5

    // Using children builder
    scrollView
      .setPaddings(.all(20))
      .addArrangedSubviews([
        nameTxt,
        phoneTxt,
        UIStackView(arrangedSubviews: [
          cancelBtn,
          submitBtn
        ])
        .setSpacing(10)
      ])
      .setCustomSpacing(20, after: nameTxt)
      .setCustomSpacing(40, after: phoneTxt)
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.bottom.leading.trailing.equalToSuperview()
    }
  }

  override func bindViewAndViewModel() {
    viewModel.rxName <~> nameTxt.rx.text => disposeBag
    viewModel.rxPhone <~> phoneTxt.rx.text => disposeBag
    viewModel.rxSaveEnabled ~> submitBtn.rx.isEnabled => disposeBag

    cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.router.dismiss()
    }) => disposeBag

    submitBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel.save()
    }) => disposeBag
  }
}

class ContactEditPageViewModel: PageViewModel {
  let contact: Contact?

  let rxName = BehaviorRelay<String?>(value: nil)
  let rxPhone = BehaviorRelay<String?>(value: nil)
  let rxSaveEnabled = BehaviorRelay(value: false)

  private let publisher = PublishRelay<Contact>()
  lazy var contactObservable = publisher.asObservable()
  
  init(contact: Contact?) {
    self.contact = contact
    super.init()
  }

  override func initialize() {
    rxName.accept(contact?.name)
    rxPhone.accept(contact?.phone)

    Observable.combineLatest(rxName, rxPhone) { name, phone -> Bool in
      !name.isNilOrEmpty && !phone.isNilOrEmpty
    } ~> rxSaveEnabled => disposeBag
  }

  fileprivate func save() {
    let contact = Contact(name: rxName.value ?? "", phone: rxPhone.value ?? "")
    publisher.accept(contact)
    router?.dismiss()
  }
}
