//
//  ContactListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm
import Action

class ContactListPage: ListPage<ContactListPageViewModel> {
    
    var addBtn: UIBarButtonItem!
    
    override func initialize() {
        super.initialize()
        
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.estimatedRowHeight = 100
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    override func cellIdentifier(_ cellViewModel: ContactCellViewModel) -> String {
        return ContactCell.identifier
    }
}

class ContactListPageViewModel: ListViewModel<Model, ContactCellViewModel> {
    
    private var count = 1
    
    lazy var addAction: Action<Void, Void> = {
        return Action() {
//            let contactModel = ContactModel(withName: "Contact name #\(self.count)")
//            self.itemsSource.append(ContactCellViewModel(model: contactModel))
//
//            self.count += 1
            
            let page = ContactPage(viewModel: ContactPageViewModel())
            let navPage = NavigationPage(rootViewController: page)
            self.navigationService.push(to: navPage, options: PushOptions(pushType: .modally, animator: TestAnimator(), animated: true))
            
            return .just(())
        }
    }()
    
    override func react() {
        
    }
}

class TestAnimator: Animator {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
            
            UIView.transition(from: fromVC.view, to: toVC.view, duration: duration, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
            
            UIView.transition(from: fromVC.view, to: toVC.view, duration: duration, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}

