//
//  NavigationTransitionExamplePage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import UIKit

enum NavigationTransitionExamplePageRoute: RouteType {
  case flip, zoom
  
  func makePage() -> UIViewController? {
    switch self {
    case .flip: return FlipPage(viewModel: PageViewModel())
    case .zoom: return ZoomPage(viewModel: PageViewModel())
    }
  }
}

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

    let layout = UIStackView(arrangedSubviews: [
      flipButton,
      zoomButton
    ])
    .setAxis(.vertical)
    .setDistribution(.fillEqually)
    .setSpacing(20)
    view.addSubview(layout)
    layout.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func bindViewAndViewModel() {
    flipButton.rx.tap.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      switch self.viewModel.menu {
      case .inNavigation:
        self.router.route(
          to: NavigationTransitionExamplePageRoute.flip,
          transition: .init(type: .push, animator: FlipAnimator(), animated: true)
        )
      case .inModal:
        self.router.route(
          to: NavigationTransitionExamplePageRoute.flip,
          transition: .init(type: .modal, animator: FlipAnimator(), animated: true)
        )
      }
    }) => disposeBag

    zoomButton.rx.tap.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      switch self.viewModel.menu {
      case .inNavigation:
        self.router.route(
          to: NavigationTransitionExamplePageRoute.flip,
          transition: .init(type: .push, animator: ZoomAnimator(), animated: true)
        )
      case .inModal:
        self.router.route(
          to: NavigationTransitionExamplePageRoute.flip,
          transition: .init(type: .modal, animator: ZoomAnimator(), animated: true)
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

  /*required init(model: MenuModel?, usingModal: Bool) {
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
  }*/
}

class FlipPage: Page<PageViewModel> {
  override func initialize() {
    enableBackButton = true

    let label = UILabel()
    label.text = "Did you see the page is flipped?"
    view.addSubview(label)
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

class ZoomPage: Page<PageViewModel> {
  override func initialize() {
    enableBackButton = true

    let label = UILabel()
    label.text = "Did you see the page zoom and switch?"
    view.addSubview(label)
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
