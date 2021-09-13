//
//  CustomControlPageExample.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import UIKit

class CustomControlExamplePage: Page<CustomControlExamplePageViewModel> {
  let segmentedView = SegmentedView(withTitles: ["Tab 1", "Tab 2", "Tab 3"])
  let label = UILabel()

  override func initialize() {
    enableBackButton = true

    view.addSubview(segmentedView)
    segmentedView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }

    view.addSubview(label)
    label.snp.makeConstraints {
      $0.top.equalTo(segmentedView.snp.bottom).offset(50)
      $0.centerY.equalToSuperview()
    }
  }

  override func bindViewAndViewModel() {
    viewModel.rxPageTitle ~> rx.title => disposeBag
    viewModel.rxSelectedIndex <~> segmentedView.rx.selectedIndex => disposeBag
    viewModel.rxSelectedText ~> label.rx.text => disposeBag
  }
}

class CustomControlExamplePageViewModel: PageViewModel {
  let rxPageTitle = BehaviorRelay<String?>(value: nil)
  let rxSelectedIndex = BehaviorRelay(value: 0)
  let rxSelectedText = BehaviorRelay<String?>(value: nil)
  
  let menu: DataBindingMenu
  init(menu: DataBindingMenu) {
    self.menu = menu
    super.init()
  }

  override func initialize() {
    rxPageTitle.accept(menu.title)
    rxSelectedIndex.map { "You have selected Tab \($0 + 1)" } ~> rxSelectedText => disposeBag
  }
}
