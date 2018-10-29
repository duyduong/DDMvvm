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

class WrapperPage: NavigationPage, IPopupView {
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.adjustPopupSize()
        }, completion: nil)
    }
    
    func popupLayout() {
        view.cornerRadius = 7
        view.autoCenterInSuperview()
        widthConstraint = view.autoSetDimension(.width, toSize: 320)
        heightConstraint = view.autoSetDimension(.height, toSize: 480)
    }
    
    func show(overlayView: UIView) {
        adjustPopupSize()
        
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.isHidden = false
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            overlayView.alpha = 1
            self.view.transform = .identity
        }, completion: nil)
    }
    
    func hide(overlayView: UIView, completion: @escaping (() -> ())) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            overlayView.alpha = 0
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            completion()
        }
    }
    
    private func adjustPopupSize() {
        guard let superview = view.superview else { return }
        if superview.bounds.height < heightConstraint.constant {
            heightConstraint.constant = superview.bounds.height - 20
        } else {
            heightConstraint.constant = 480
        }
        
        if superview.bounds.width < widthConstraint.constant {
            widthConstraint.constant = superview.bounds.width - 20
        } else {
            widthConstraint.constant = 320
        }
        
        view.layoutIfNeeded()
    }
}

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
    
    override func onBack() {
        navigationService.pop(with: PopOptions(popType: .dismissPopup))
    }
}

class ContactEditPageViewModel: ViewModel<ContactModel> {
    
    lazy var cancelAction: Action<Void, Void> = {
        return Action() { .just(self.navigationService.pop(with: PopOptions(popType: .dismissPopup))) }
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
        
        navigationService.pop(with: PopOptions(popType: .dismissPopup))
        
        return .just(contact)
    }
}










