//
//  ContactEditPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DDMvvm

class WrapperPage: NavigationPage {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.cornerRadius = 10
  }
}

extension WrapperPage: PopupPresenting {
  var layout: PopupLayout {
    .center(width: .pinEdge(insets: 24), height: .fixed(480))
  }
}

class ContactEditPage: Page<ContactEditPageViewModel> {
  
  let scrollView = ScrollLayout()
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
    
    scrollView.paddings(.all(20)).interitemSpacing(20).childrenBuilder {
      nameTxt
      phoneTxt
      StackLayout().justifyContent(.fillEqually).spacing(10).childrenBuilder {
        cancelBtn
        submitBtn
      }
    }
    view.addSubview(scrollView)
    scrollView.autoPinEdge(toSuperviewSafeArea: .top)
    scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
  }
  
  override func bindViewAndViewModel() {
    guard let viewModel = viewModel else { return }
    
    viewModel.rxName <~> nameTxt.rx.text => disposeBag
    viewModel.rxPhone <~> phoneTxt.rx.text => disposeBag
    viewModel.rxSaveEnabled ~> submitBtn.rx.isEnabled => disposeBag
    
    cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.navigationService.pop(with: .dismissPopup)
    }) => disposeBag
    
    submitBtn.rx.tap.subscribe(onNext: { [weak self] in
      self?.viewModel?.save()
    }) => disposeBag
  }
  
  override func onBack() {
    navigationService.pop(with: .dismissPopup)
  }
}

class ContactEditPageViewModel: ViewModel<ContactModel> {
  
  let rxName = BehaviorRelay<String?>(value: nil)
  let rxPhone = BehaviorRelay<String?>(value: nil)
  let rxSaveEnabled = BehaviorRelay(value: false)
  
  private let publisher = PublishSubject<ContactModel>()
  lazy var contactObservable = publisher.asObservable()
  
  override func react() {
    rxName.accept(model?.name)
    rxPhone.accept(model?.phone)
    
    Observable.combineLatest(rxName, rxPhone) { name, phone -> Bool in
      return !name.isNilOrEmpty && !phone.isNilOrEmpty
    } ~> rxSaveEnabled => disposeBag
  }
  
  fileprivate func save() {
    let contact = ContactModel(name: rxName.value ?? "", phone: rxPhone.value ?? "")
    publisher.onNext(contact)
    
    navigationService.pop(with: .dismissPopup)
  }
}










