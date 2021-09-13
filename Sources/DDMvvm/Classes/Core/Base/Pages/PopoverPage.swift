//
//  PopoverPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 13/09/2021.
//

import UIKit
import RxSwift

public class PopoverPage: UIViewController, IDestroyable {
  struct PopoverOption {
    let source: SourceType
    let backgroundColor: UIColor?
    let locationView: UIView?
    let permittedArrowDirections: UIPopoverArrowDirection
  }
  
  private var contentPage: UIViewController?
  private var contentView: UIView?
  private var option: PopoverOption?

  public init(contentPage: UIViewController) {
    self.contentPage = contentPage
    super.init(nibName: nil, bundle: nil)
  }

  public init(contentView: UIView) {
    self.contentView = contentView
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    if let contentPage = contentPage {
      view.addSubview(contentPage.view)
      contentPage.view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }

      addChild(contentPage)
      contentPage.didMove(toParent: self)

      contentPage.rx.observeWeakly(CGSize.self, "preferredContentSize").subscribe(onNext: { [weak self] contentSize in
        guard let self = self, let contentSize = contentSize else {
          return
        }
        if contentSize != .zero {
          self.preferredContentSize = contentSize
        } else {
          self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
      }) => disposeBag
    }

    if let contentView = contentView {
      view.addSubview(contentView)
      contentView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }

    // Save option
    if let popoverView = contentPage as? IPopoverView ?? contentView as? IPopoverView {
      option = .init(
        source: popoverView.sourceType,
        backgroundColor: popoverView.backgroundColor,
        locationView: popoverView.locationView,
        permittedArrowDirections: popoverView.permittedArrowDirections()
      )
    }
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if contentView != nil {
      preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
  }

  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    destroy()
  }
  
  public func destroy() {
    (contentPage as? IDestroyable)?.destroy()
    (contentView as? IDestroyable)?.destroy()
    contentPage?.removeFromParent()
    disposeBag = DisposeBag()
  }

  func present(from page: UIViewController, completion: (() -> Void)? = nil) {
    modalPresentationStyle = .popover

    popoverPresentationController?.permittedArrowDirections = option?.permittedArrowDirections ?? [.any]
    switch option?.source {
    case let .barItem(item):
      popoverPresentationController?.barButtonItem = item

    case let .sourceView(view, rect):
      popoverPresentationController?.sourceView = view
      popoverPresentationController?.sourceRect = rect ?? view.frame

    case nil:
      break
    }

    popoverPresentationController?.backgroundColor = option?.backgroundColor
    popoverPresentationController?.delegate = self

    page.present(self, animated: true, completion: completion)
  }
}

extension PopoverPage: UIPopoverPresentationControllerDelegate {
  public func adaptivePresentationStyle(
    for controller: UIPresentationController
  ) -> UIModalPresentationStyle {
    .none
  }
}
