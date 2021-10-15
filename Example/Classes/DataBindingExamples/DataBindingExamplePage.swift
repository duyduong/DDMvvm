//
//  DataBindingExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DDMvvm

class DataBindingExamplePage: Page<DataBindingExamplePageViewModel> {

    let scrollView = ScrollLayout()
    let containerView = UIView()
    
    let helloLbl = UILabel()
    let emailTxt = UITextField()
    let passTxt = UITextField()
    let submitBtn = UIButton(type: .custom)
    
    override func initialize() {
        enableBackButton = true
        
        view.addSubview(scrollView)
        scrollView.autoPinEdge(toSuperviewSafeArea: .top)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
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

        scrollView.paddings(.all(20)).appendChildren([
            StackSpaceItem(height: 30),
            helloLbl,
            StackSpaceItem(height: 30),
            emailTxt,
            StackSpaceItem(height: 20),
            passTxt,
            StackSpaceItem(height: 20),
            StackViewItem(view: submitBtn) { view in
                view.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
            },
            StackSpaceItem(height: 50),
        ])
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag // One-way binding is donated by ~>
        viewModel.rxHelloText ~> helloLbl.rx.text => disposeBag // One-way binding is donated by ~>
        viewModel.rxEmail <~> emailTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        viewModel.rxPass <~> passTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        
        viewModel.rxSubmitButtonEnabled ~> submitBtn.rx.isEnabled => disposeBag
        submitBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel?.submitPressed()
        }) => disposeBag
    }
}

class DataBindingExamplePageViewModel: ViewModel<MenuModel> {
    
    let rxPageTitle = BehaviorRelay<String?>(value: nil)
    let rxHelloText = BehaviorRelay<String?>(value: nil)
    let rxEmail = BehaviorRelay<String?>(value: nil)
    let rxPass = BehaviorRelay<String?>(value: nil)
    let rxSubmitButtonEnabled = BehaviorRelay(value: false)
    
    override func react() {
        rxPageTitle.accept(model?.title ?? "")
        
        Observable.combineLatest(rxEmail, rxPass) { e, p -> Bool in
            return !e.isNilOrEmpty && !p.isNilOrEmpty
        } ~> rxSubmitButtonEnabled => disposeBag // One-way binding is donated by ~>
        
        rxEmail.filter { $0 != nil }.map { "Hello, \($0!)" } ~> rxHelloText => disposeBag  // One-way binding is donated by ~>
    }
    
    fileprivate func submitPressed() {
        let email = self.rxEmail.value ?? ""
        let pass = self.rxPass.value ?? ""
        
        let alertService: IAlertService = DependencyManager.shared.getService()
        alertService.presentOkayAlert(
            title: "Submit Button Clicked!",
            message: "You have just clicked on submit button. Here are your credentials:\nEmail: \(email)\nPass: \(pass)"
        )
    }
}









