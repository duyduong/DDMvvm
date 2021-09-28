//
//  DataBindingExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import RxSwift
import UIKit

class DataBindingExamplePage: Page<DataBindingExamplePageViewModel> {
  let scrollView = ScrollableStackView()
  let containerView = UIView()

  let helloLbl = UILabel()
  let emailTxt = UITextField()
  let passTxt = UITextField()
  let submitBtn = UIButton(type: .custom)

  override func initialize() {
    helloLbl.font = UIFont.preferredFont(forTextStyle: .title3)

    emailTxt.borderStyle = .roundedRect
    emailTxt.placeholder = "Enter your name"

    passTxt.borderStyle = .roundedRect
    passTxt.placeholder = "Enter your pass"
    passTxt.isSecureTextEntry = true

    submitBtn.setTitle("Submit", for: .normal)
    submitBtn.setTitleColor(.white, for: .normal)
    submitBtn.setTitleColor(.lightGray, for: .disabled)
    submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
    submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
    submitBtn.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
    submitBtn.cornerRadius = 5
    
    let submitView = UIView()
    submitView.addSubview(submitBtn)
    submitBtn.snp.makeConstraints {
      $0.trailing.top.bottom.equalToSuperview()
    }

    scrollView
      .setPaddings(NSDirectionalEdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 20))
      .addArrangedSubviews([
        helloLbl,
        emailTxt,
        passTxt,
        submitView
      ])
      .setCustomSpacing(30, after: helloLbl)
      .setCustomSpacing(20, after: emailTxt)
      .setCustomSpacing(20, after: passTxt)
      .setCustomSpacing(50, after: submitView)
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.leading.trailing.equalToSuperview()
    }
  }

  override func bindViewAndViewModel() {
    viewModel.rxPageTitle ~> rx.title => disposeBag // One-way binding is donated by ~>
    viewModel.rxHelloText ~> helloLbl.rx.text => disposeBag // One-way binding is donated by ~>
    viewModel.rxEmail <~> emailTxt.rx.text => disposeBag // Two-way binding is donated by <~>
    viewModel.rxPass <~> passTxt.rx.text => disposeBag // Two-way binding is donated by <~>

    viewModel.rxSubmitButtonEnabled ~> submitBtn.rx.isEnabled => disposeBag
    submitBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.submitPressed()
    }) => disposeBag
  }
  
  private func submitPressed() {
    let email = emailTxt.text ?? ""
    let pass = passTxt.text ?? ""

    schedule(
      alert: .ok(
        title: "Submit Button Clicked!",
        message: "You have just clicked on submit button. Here are your credentials:\nEmail: \(email)\nPass: \(pass)"
      ),
      completion: nil
    )
  }
}

extension DataBindingExamplePage: Alertable {
  typealias Alert = DefaultAlert
}

class DataBindingExamplePageViewModel: PageViewModel {
  let rxPageTitle = BehaviorRelay<String?>(value: nil)
  let rxHelloText = BehaviorRelay<String?>(value: nil)
  let rxEmail = BehaviorRelay<String?>(value: nil)
  let rxPass = BehaviorRelay<String?>(value: nil)
  let rxSubmitButtonEnabled = BehaviorRelay(value: false)
  
  let menu: DataBindingMenu
  
  init(menu: DataBindingMenu) {
    self.menu = menu
    super.init()
  }

  override func initialize() {
    rxPageTitle.accept(menu.title)

    Observable.combineLatest(rxEmail, rxPass) { e, p -> Bool in
      !e.isNilOrEmpty && !p.isNilOrEmpty
    } ~> rxSubmitButtonEnabled => disposeBag // One-way binding is donated by ~>

    rxEmail.filter { $0 != nil }.map { "Hello, \($0!)" } ~> rxHelloText => disposeBag // One-way binding is donated by ~>
  }
}
