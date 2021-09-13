//
//  PopupPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/20/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import RxSwift
import UIKit

class OverlayView: AbstractControlView {
  let tapGesture = UITapGestureRecognizer()

  override func setupView() {
    backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    addGestureRecognizer(tapGesture)
  }

  static func addToPage(_ page: UIViewController) -> OverlayView {
    let overlayView = OverlayView()
    page.view.addSubview(overlayView)
    overlayView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    return overlayView
  }
}

public class PopupPage: UIViewController, IDestroyable {
  override public var prefersStatusBarHidden: Bool {
    contentPage.prefersStatusBarHidden
  }

  override public var preferredStatusBarStyle: UIStatusBarStyle {
    contentPage.preferredStatusBarStyle
  }

  private let contentPage: UIViewController
  private lazy var overlayView = OverlayView.addToPage(self)

  private var shouldDismissOnTapOutside = true
  private var showCompletion: (() -> Void)?
  private var isShown = false

  public init(contentPage: UIViewController, showCompletion: (() -> Void)? = nil) {
    self.contentPage = contentPage
    self.showCompletion = showCompletion
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(contentPage:)")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    overlayView.alpha = 0

    contentPage.view.isHidden = true
    addChild(contentPage)
    view.addSubview(contentPage.view)
    if let popupView = contentPage as? IPopupView {
      shouldDismissOnTapOutside = popupView.shouldDismissOnTapOutside
      overlayView.backgroundColor = popupView.overlayColor
      popupView.makeConstraints()
    } else {
      contentPage.view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }

    contentPage.didMove(toParent: self)

    overlayView.tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
      guard let self = self, self.shouldDismissOnTapOutside else { return }
      self.dismiss(animated: false)
    }) => disposeBag
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    show()
  }

  override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    guard let popupView = contentPage as? IPopupView else {
      return super.dismiss(animated: false, completion: {
        self.destroy()
        completion?()
      })
    }
    popupView.hide(overlayView: overlayView) {
      super.dismiss(animated: false, completion: {
        self.destroy()
        completion?()
      })
    }
  }

  public func destroy() {
    (contentPage as? IDestroyable)?.destroy()
    disposeBag = DisposeBag()

    contentPage.removeFromParent()

    // if this presenter page is added as a child on another controller
    // then remove it
    if let _ = parent {
      removeFromParent()
    }
  }

  // MARK: - Toggle content view

  public func show() {
    if isShown { return }
    isShown = true
    
    guard let popupView = contentPage as? IPopupView else { return }

    CATransaction.begin()
    CATransaction.setCompletionBlock(showCompletion)
    popupView.show(overlayView: overlayView)
    CATransaction.commit()
  }
}
