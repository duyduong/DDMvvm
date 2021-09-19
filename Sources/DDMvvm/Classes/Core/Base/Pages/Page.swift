//
//  Page.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit

open class Page<VM: IPageViewModel>: UIViewController, IRoutable, IDestroyable {
  public private(set) lazy var router = createRouter()
  public let viewModel: VM

  private var backDisposable: Disposable?

  public init(viewModel: VM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.router = router
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Use init(viewModel:)")
  }

  deinit { destroy() }

  /// Subclasses override this method to initialize UIs.
  ///
  /// This method is called in `viewDidLoad`. So try not to use `viewModel` property if you are not sure about it
  open func initialize() {}

  override open func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    // Adding a custom back button
    if let backButton = customBackBarButton() {
      navigationItem.leftBarButtonItem = backButton

      backDisposable?.dispose()
      backDisposable = backButton.rx.tap.subscribe(onNext: { [weak self] _ in
        self?.backBarButtonPressed()
      })
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

  /// Factory for create own router
  open func createRouter() -> RouterType {
    DefaultRouter(rootViewController: self)
  }

  /// Factory for custom back bar button item
  /// - Returns: `UIBarButtonItem`
  open func customBackBarButton() -> UIBarButtonItem? {
    nil
  }

  /**
   Subclasses override this method to create data binding between view and viewModel.

   This method always happens, so subclasses should check if viewModel is nil or not. For example:
   ```
   guard let viewModel = viewModel else { return }
   ```
   */
  open func bindViewAndViewModel() {}

  /// Subclasses override this method to remove all things related to `DisposeBag`.
  open func destroy() {
    disposeBag = DisposeBag()
    viewModel.destroy()
  }

  /// Subclasses override this method to create custom back action for back button.
  ///
  /// By default, this will call pop action in navigation or dismiss in modal
  open func backBarButtonPressed() {
    router.dismiss()
  }
}
