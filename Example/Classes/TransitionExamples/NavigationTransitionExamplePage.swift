//
//  NavigationTransitionExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

enum NavigationTransitionRoute: RouteType {
  case flip, zoom
  
  func makePage() -> UIViewController? {
    switch self {
    case .flip: return FlipPage(viewModel: PageViewModel())
    case .zoom: return ZoomPage(viewModel: PageViewModel())
    }
  }
}

class NavigationTransitionExamplePage: Page<NavigationTransitionExamplePageViewModel>, Routable {
  typealias Route = NavigationTransitionRoute

  let flipButton = UIButton(type: .custom)
  let zoomButton = UIButton(type: .custom)

  override func initialize() {
    flipButton.setTitle("Push Flip", for: .normal)
    flipButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
    flipButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)

    zoomButton.setTitle("Zoom and Switch", for: .normal)
    zoomButton.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
    zoomButton.contentEdgeInsets = .symmetric(horizontal: 10, vertical: 5)

    let layout = UIStackView(arrangedSubviews: [
      flipButton,
      zoomButton
    ])
    .setDistribution(.fillEqually)
    .setSpacing(20)
    view.addSubview(layout)
    layout.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
    }
  }

  override func bindViewAndViewModel() {
    flipButton.rx.tap.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      switch self.viewModel.menu {
      case .inNavigation:
        self.route(
          to: .flip,
          transition: Transition(type: .push, animator: FlipAnimator()),
          completion: nil
        )
      case .inModal:
        self.route(
          to: .flip,
          transition: Transition(type: .modal, animator: FlipAnimator()),
          completion: nil
        )
      }
    }) => disposeBag

    zoomButton.rx.tap.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      switch self.viewModel.menu {
      case .inNavigation:
        self.route(
          to: .zoom,
          transition: .init(type: .push, animator: ZoomAnimator()),
          completion: nil
        )
      case .inModal:
        self.route(
          to: .zoom,
          transition: .init(type: .modal, animator: ZoomAnimator()),
          completion: nil
        )
      }
    }) => disposeBag
  }
}

class NavigationTransitionExamplePageViewModel: PageViewModel {
  let menu: TransitionMenu
  
  init(menu: TransitionMenu) {
    self.menu = menu
    super.init()
  }
}

class FlipPage: Page<PageViewModel>, Dismissable {
  override func initialize() {
    let label = UILabel()
    label.text = "Did you see the page is flipped?"
    view.addSubview(label)
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    if transition?.type == .modal {
      let dismissButton = UIButton()
      dismissButton.setTitle("Dismiss", for: .normal)
      dismissButton.setTitleColor(.systemBlue, for: .normal)
      dismissButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
      view.addSubview(dismissButton)
      dismissButton.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().inset(50)
      }
    }
  }
  
  @objc
  func goBack() {
    dismiss()
  }
}

class ZoomPage: Page<PageViewModel>, Dismissable {
  override func initialize() {
    let label = UILabel()
    label.text = "Did you see the page zoom and switch?"
    view.addSubview(label)
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    if transition?.type == .modal {
      let dismissButton = UIButton()
      dismissButton.setTitle("Dismiss", for: .normal)
      dismissButton.setTitleColor(.systemBlue, for: .normal)
      dismissButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
      view.addSubview(dismissButton)
      dismissButton.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().inset(50)
      }
    }
  }
  
  @objc
  func goBack() {
    dismiss()
  }
}
