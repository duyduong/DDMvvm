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
import Action
import DDMvvm

class DataBindingExamplePage: Page<DataBindingExamplePageViewModel> {

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let helloLbl = UILabel()
    let emailTxt = UITextField()
    let passTxt = UITextField()
    let submitBtn = UIButton(type: .custom)
    
    override func initialize() {
        enableBackButton = true
        
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.autoPin(toTopLayoutOf: self)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        
        helloLbl.font = Font.system.bold(withSize: 18)
        containerView.addSubview(helloLbl)
        helloLbl.autoPinEdge(toSuperviewEdge: .top, withInset: 30)
        helloLbl.autoAlignAxis(toSuperviewAxis: .vertical)
        
        emailTxt.borderStyle = .roundedRect
        emailTxt.placeholder = "Enter your name"
        containerView.addSubview(emailTxt)
        emailTxt.autoPinEdge(.top, to: .bottom, of: helloLbl, withOffset: 30)
        emailTxt.autoAlignAxis(toSuperviewAxis: .vertical)
        emailTxt.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
        
        passTxt.borderStyle = .roundedRect
        passTxt.placeholder = "Enter your pass"
        passTxt.isSecureTextEntry = true
        containerView.addSubview(passTxt)
        passTxt.autoMatch(.width, to: .width, of: emailTxt)
        passTxt.autoPinEdge(.top, to: .bottom, of: emailTxt, withOffset: 20)
        passTxt.autoAlignAxis(toSuperviewAxis: .vertical)
        
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitleColor(.lightGray, for: .disabled)
        submitBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        submitBtn.setBackgroundImage(UIImage.from(color: .gray), for: .disabled)
        submitBtn.contentEdgeInsets = .topBottom(5, leftRight: 10)
        submitBtn.cornerRadius = 5
        containerView.addSubview(submitBtn)
        submitBtn.autoConstrainAttribute(.trailing, to: .trailing, of: passTxt)
        submitBtn.autoPinEdge(.top, to: .bottom, of: passTxt, withOffset: 20)
        submitBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag // One-way binding is donated by ~>
        viewModel.rxHelloText ~> helloLbl.rx.text => disposeBag // One-way binding is donated by ~>
        viewModel.rxEmail <~> emailTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        viewModel.rxPass <~> passTxt.rx.text => disposeBag // Two-way binding is donated by <~>
        submitBtn.rx.bind(to: viewModel.submitAction, input: ()) // action binding
    }
}

class DataBindingExamplePageViewModel: ViewModel<MenuModel> {
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    let rxHelloText = BehaviorRelay<String?>(value: nil)
    let rxEmail = BehaviorRelay<String?>(value: nil)
    let rxPass = BehaviorRelay<String?>(value: nil)
    let rxSubmitButtonEnabled = BehaviorRelay(value: false)
    
    lazy var submitAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxSubmitButtonEnabled.asObservable()) {
            let email = self.rxEmail.value ?? ""
            let pass = self.rxPass.value ?? ""
            self.alertService.presentOkayAlert(title: "Submit Button Clicked!",
                                               message: "You have just clicked on submit button. Here are your credentials:\nEmail: \(email)\nPass: \(pass)")
            return .just(())
        }
    }()
    
    let alertService: IAlertService = DependencyManager.shared.getService()
    
    override func react() {
        rxPageTitle.accept(model?.title ?? "")
        
        Observable.combineLatest(rxEmail.asObservable(), rxPass.asObservable()) { e, p -> Bool in
            return !e.isNilOrEmpty && !p.isNilOrEmpty
        } ~> rxSubmitButtonEnabled => disposeBag // One-way binding is donated by ~>
        
        rxEmail.filterNil().map { "Hello, \($0)" } ~> rxHelloText => disposeBag  // One-way binding is donated by ~>
    }
}









