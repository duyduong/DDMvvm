//
//  Page.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

open class Page<VM: IPageViewModel>: UIViewController, IDestroyable {
  public let viewModel: VM

  public init(viewModel: VM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(viewModel:)")
  }

  deinit { destroy() }

  /// Subclasses override this method to initialize UIs.
  open func initialize() {}

  override open func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    // Adding a custom back button
    if let backButton = createCustomBackButton() {
      navigationItem.leftBarButtonItem = backButton
      backButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
          self?.customBackButtonPressed()
        })
        .disposed(by: disposeBag)
    }

    initialize()
    bindViewAndViewModel()
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (viewModel as? InternalPageViewModel)?.pageLifeCycleRelay.accept(.willAppear)
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    (viewModel as? InternalPageViewModel)?.pageLifeCycleRelay.accept(.didAppear)
  }

  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    (viewModel as? InternalPageViewModel)?.pageLifeCycleRelay.accept(.willDisappear)
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    (viewModel as? InternalPageViewModel)?.pageLifeCycleRelay.accept(.didDisappear)

    if isMovingFromParent { destroy() }
  }

  /// Factory for custom back bar button item
  /// - Returns: `UIBarButtonItem`
  open func createCustomBackButton() -> UIBarButtonItem? { nil }

  /// This method will call after `initialize()`
  open func bindViewAndViewModel() {}

  /// Subclasses override this method to remove all things related to `DisposeBag`.
  open func destroy() {
    disposeBag = DisposeBag()
    viewModel.destroy()
  }

  /// Subclasses override this method to create custom back action for back button.
  /// This method only called when there is a custom back button implemented using `customBackBarButton()`
  open func customBackButtonPressed() {}
}
