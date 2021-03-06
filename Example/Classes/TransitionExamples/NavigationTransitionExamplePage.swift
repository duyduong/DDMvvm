//
//  NavigationTransitionExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class NavigationTransitionExamplePage: Page<NavigationTransitionExamplePageViewModel> {
    
    let flipButton = UIButton(type: .custom)
    let zoomButton = UIButton(type: .custom)
    
    override func initialize() {
        enableBackButton = true
        
        flipButton.setTitle("Push Flip", for: .normal)
        flipButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        flipButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        
        zoomButton.setTitle("Zoom and Switch", for: .normal)
        zoomButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        zoomButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)
        
        let layout = StackLayout().direction(.vertical).justifyContent(.fillEqually).spacing(20).children([
            flipButton,
            zoomButton
        ])
        view.addSubview(layout)
        layout.autoCenterInSuperview()
    }
    
    override func bindViewAndViewModel() {
        flipButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel?.pushFlip()
        }) => disposeBag
        
        zoomButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel?.pushZoom()
        }) => disposeBag
    }
}

class NavigationTransitionExamplePageViewModel: ViewModel<MenuModel> {
    
    let usingModal: Bool
    
    required init(model: MenuModel?, usingModal: Bool) {
        self.usingModal = usingModal
        super.init(model: model)
    }
    
    required init(model: MenuModel?) {
        usingModal = false
        super.init(model: model)
    }
    
    fileprivate func pushFlip() {
        let page = FlipPage(viewModel: ViewModel<Any>())
        let animator = FlipAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, type: .modally(presentationStyle: .fullScreen, animated: true, animator: animator))
        } else {
            navigationService.push(to: page, type: .push(animated: true, animator: animator))
        }
    }
    
    fileprivate func pushZoom() {
        let page = ZoomPage(viewModel: ViewModel<Any>())
        let animator = ZoomAnimator()
        if usingModal {
            let navPage = NavigationPage(rootViewController: page)
            navigationService.push(to: navPage, type: .modally(presentationStyle: .fullScreen, animated: true, animator: animator))
        } else {
            navigationService.push(to: page, type: .push(animated: true, animator: animator))
        }
    }
}

class FlipPage: Page<ViewModel<Any>> {
    
    override func initialize() {
        enableBackButton = true
        
        let label = UILabel()
        label.text = "Did you see the page is flipped?"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: .dismiss(animated: true))
        } else {
            super.onBack()
        }
    }
}

class ZoomPage: Page<ViewModel<Any>> {
    
    override func initialize() {
        enableBackButton = true
        
        let label = UILabel()
        label.text = "Did you see the page zoom and switch?"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: .dismiss(animated: true))
        } else {
            super.onBack()
        }
    }
}



