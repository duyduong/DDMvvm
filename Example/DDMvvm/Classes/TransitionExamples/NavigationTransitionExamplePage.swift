//
//  NavigationTransitionExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Action
import DDMvvm

class NavigationTransitionExamplePage: Page<NavigationTransitionExamplePageViewModel> {
    
    let flipButton = UIButton(type: .custom)
    let zoomButton = UIButton(type: .custom)
    
    override func initialize() {
        enableBackButton = true
        
        let centerView = UIView()
        view.addSubview(centerView)
        centerView.autoCenterInSuperview()
        
        flipButton.setTitle("Push Flip", for: .normal)
        flipButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        flipButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        centerView.addSubview(flipButton)
        flipButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        zoomButton.setTitle("Zoom and Switch", for: .normal)
        zoomButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        zoomButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        centerView.addSubview(zoomButton)
        zoomButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        zoomButton.autoPinEdge(.top, to: .bottom, of: flipButton, withOffset: 20)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        flipButton.rx.bind(to: viewModel.flipAction, input: ())
        zoomButton.rx.bind(to: viewModel.zoomAction, input: ())
    }
}

class NavigationTransitionExamplePageViewModel: ViewModel<MenuModel> {
    
    lazy var flipAction: Action<Void, Void> = {
        return Action() { .just(self.pushFlip()) }
    }()
    
    lazy var zoomAction: Action<Void, Void> = {
        return Action() { .just(self.pushZoom()) }
    }()
    
    let usingModal: Bool
    
    required init(model: MenuModel?, usingModal: Bool) {
        self.usingModal = usingModal
        super.init(model: model)
    }
    
    required init(model: MenuModel?) {
        usingModal = false
        super.init(model: model)
    }
    
    private func pushFlip() {
        let page = FlipPage(viewModel: ViewModel<Model>())
        let animator = FlipAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, options: .modalWithAnimator(animator))
        } else {
            navigationService.push(to: page, options: .pushWithAnimator(animator))
        }
    }
    
    private func pushZoom() {
        let page = ZoomPage(viewModel: ViewModel<Model>())
        let animator = ZoomAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, options: .modalWithAnimator(animator))
        } else {
            navigationService.push(to: page, options: .pushWithAnimator(animator))
        }
    }
}

class FlipPage: Page<ViewModel<Model>> {
    
    override func initialize() {
        enableBackButton = true
        
        let label = UILabel()
        label.text = "Did you see the page is flipped?"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
           navigationService.pop(with: PopOptions(popType: .dismiss, animated: true))
        } else {
            super.onBack()
        }
    }
}

class ZoomPage: Page<ViewModel<Model>> {
    
    override func initialize() {
        enableBackButton = true
        
        let label = UILabel()
        label.text = "Did you see the page zoom and switch?"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: PopOptions(popType: .dismiss, animated: true))
        } else {
            super.onBack()
        }
    }
}



