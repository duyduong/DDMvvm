//
//  ContactEditPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa
import DDMvvm

class ContactEditPage: Page<ContactEditPageViewModel> {

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let nameTxt = UITextField()
    let phoneTxt = UITextField()
    let submitBtn = UIButton(type: .custom)
    let cancelBtn = UIButton(type: .custom)
    
    override func initialize() {
        title = "Add/Edit Contact"
        
        enableBackButton = true
        
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.autoPin(toTopLayoutOf: self)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        
        nameTxt.borderStyle = .roundedRect
        nameTxt.placeholder = "Enter your name"
        containerView.addSubview(nameTxt)
        nameTxt.autoPinEdge(toSuperviewEdge: .top, withInset: 40)
        nameTxt.autoAlignAxis(toSuperviewAxis: .vertical)
        nameTxt.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
        
        phoneTxt.borderStyle = .roundedRect
        phoneTxt.placeholder = "Enter your phone number"
        containerView.addSubview(phoneTxt)
        phoneTxt.autoMatch(.width, to: .width, of: nameTxt)
        phoneTxt.autoPinEdge(.top, to: .bottom, of: nameTxt, withOffset: 20)
        phoneTxt.autoAlignAxis(toSuperviewAxis: .vertical)
        
        let buttonView = UIView()
        containerView.addSubview(buttonView)
        buttonView.autoAlignAxis(toSuperviewAxis: .vertical)
        buttonView.autoMatch(.width, to: .width, of: phoneTxt)
        buttonView.autoPinEdge(.top, to: .bottom, of: phoneTxt, withOffset: 20)
        buttonView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setBackgroundImage(UIImage.from(color: .red), for: .normal)
        cancelBtn.contentEdgeInsets = .topBottom(5, leftRight: 10)
        cancelBtn.cornerRadius = 5
        buttonView.addSubview(cancelBtn)
        cancelBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        
        submitBtn.setTitle("Save", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitleColor(.lightGray, for: .disabled)
        submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
        submitBtn.contentEdgeInsets = .topBottom(5, leftRight: 10)
        submitBtn.cornerRadius = 5
        buttonView.addSubview(submitBtn)
        submitBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        submitBtn.autoPinEdge(.leading, to: .trailing, of: cancelBtn, withOffset: 10)
        submitBtn.autoMatch(.width, to: .width, of: cancelBtn)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxName <~> nameTxt.rx.text => disposeBag
        viewModel.rxPhone <~> phoneTxt.rx.text => disposeBag
        
        cancelBtn.rx.bind(to: viewModel.cancelAction, input: ())
        submitBtn.rx.bind(to: viewModel.saveAction, input: ())
    }
}

class ContactEditPageViewModel: ViewModel<ContactModel> {
    
    lazy var cancelAction: Action<Void, Void> = {
        return Action() { .just(self.navigationService.pop()) }
    }()
    
    lazy var saveAction: Action<Void, ContactModel> = {
        return Action(enabledIf: self.rxSaveEnabled.asObservable()) {
            return self.save()
        }
    }()
    
    let rxName = BehaviorRelay<String?>(value: nil)
    let rxPhone = BehaviorRelay<String?>(value: nil)
    let rxSaveEnabled = BehaviorRelay(value: false)
    
    override func react() {
        rxName.accept(model?.name)
        rxPhone.accept(model?.phone)
        
        Observable.combineLatest(rxName, rxPhone) { name, phone -> Bool in
            return !name.isNilOrEmpty && !phone.isNilOrEmpty
        } ~> rxSaveEnabled => disposeBag
    }
    
    private func save() -> Observable<ContactModel> {
        let contact = ContactModel()
        contact.name = rxName.value ?? ""
        contact.phone = rxPhone.value ?? ""
        
        navigationService.pop()
        
        return .just(contact)
    }
}










