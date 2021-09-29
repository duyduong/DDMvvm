//
//  CustomControlPageExample.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class CustomControlExamplePage: Page<CustomControlExamplePageViewModel> {

    let segmentedView = SegmentedView(withTitles: ["Tab 1", "Tab 2", "Tab 3"])
    
    let label = UILabel()
    
    override func initialize() {
        enableBackButton = true
        
        view.addSubview(segmentedView)
        segmentedView.autoPinEdge(toSuperviewSafeArea: .top)
        segmentedView.autoPinEdge(toSuperviewEdge: .leading)
        segmentedView.autoPinEdge(toSuperviewEdge: .trailing)
        
        view.addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: segmentedView, withOffset: 50)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
        viewModel.rxSelectedIndex <~> segmentedView.rx.selectedIndex => disposeBag
        viewModel.rxSelectedText ~> label.rx.text => disposeBag
    }
}

class CustomControlExamplePageViewModel: ViewModel<MenuModel> {
    
    let rxPageTitle = BehaviorRelay<String?>(value: nil)
    let rxSelectedIndex = BehaviorRelay(value: 0)
    let rxSelectedText = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        rxPageTitle.accept(model?.title ?? "")
        rxSelectedIndex.map { "You have selected Tab \($0 + 1)" } ~> rxSelectedText => disposeBag
    }
}









