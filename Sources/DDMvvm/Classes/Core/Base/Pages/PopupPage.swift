//
//  PopupPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/20/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift

public final class PopupPage: UIViewController {
  private class OverlayView: AbstractControlView {
    let tapGesture = UITapGestureRecognizer()

    override func setupView() {
      backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
      addGestureRecognizer(tapGesture)
    }

    static func addToPage(_ page: UIViewController) -> OverlayView {
      let overlayView = OverlayView()
      page.view.addSubview(overlayView)
      overlayView.autoPinEdgesToSuperviewEdges()

      return overlayView
    }
  }

  public override var prefersStatusBarHidden: Bool {
    contentPage.prefersStatusBarHidden
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    contentPage.preferredStatusBarStyle
  }

  let contentPage: UIViewController
  private lazy var overlayView = OverlayView.addToPage(self)

  private var shouldDismissOnTapOutside = true
  private var showCompletion: (() -> Void)?
  private var isShown = false

  private var window: UIWindow?

  public init(contentPage: UIViewController, showCompletion: (() -> Void)? = nil) {
    self.contentPage = contentPage
    self.showCompletion = showCompletion
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(contentPage:)")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    overlayView.alpha = 0

    contentPage.view.isHidden = true
    addChild(contentPage)
    view.addSubview(contentPage.view)
    if let popupView = contentPage as? PopupPresenting {
      shouldDismissOnTapOutside = popupView.shouldDismissOnTapOutside
      overlayView.backgroundColor = popupView.overlayColor
      popupView.makeConstraints()
    } else {
      contentPage.view.autoPinEdgesToSuperviewEdges()
    }

    contentPage.didMove(toParent: self)

    overlayView.tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
      guard let self = self, self.shouldDismissOnTapOutside else { return }
      self.dismiss(animated: false)
    }) => disposeBag
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    show()
  }

  public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    hide(completion: completion)
  }

  public override func destroy() {
    contentPage.destroy()
    disposeBag = DisposeBag()

    window?.isHidden = true
    window = nil
  }

  // MARK: - Toggle content view

  private func hide(completion: (() -> Void)?) {
    guard let popupView = contentPage as? PopupPresenting else {
      destroy()
      completion?()
      return
    }
    popupView.hide(overlayView: overlayView) { [weak self] in
      self?.destroy()
      completion?()
    }
  }

  private func show() {
    if isShown { return }
    isShown = true

    guard let popupView = contentPage as? PopupPresenting else { return }

    CATransaction.begin()
    CATransaction.setCompletionBlock(showCompletion)
    popupView.show(overlayView: overlayView)
    CATransaction.commit()
  }
}

extension PopupPage {
  /// Present the content page as a popup, PopupPage will be the root view controller in a new window
  /// - Parameters:
  ///   - contentPage: Popup view controller
  ///   - showCompletion: Show completion block
  static func present(contentPage: UIViewController, showCompletion: (() -> Void)?) {
    let page = PopupPage(contentPage: contentPage, showCompletion: showCompletion)
    page.modalPresentationStyle = .overFullScreen

    let window = UIWindow(frame: UIScreen.main.bounds)
    page.window = window
    window.rootViewController = page
    window.backgroundColor = .clear
    window.windowLevel = UIWindow.Level.alert + 1
    window.makeKeyAndVisible()
  }
}
