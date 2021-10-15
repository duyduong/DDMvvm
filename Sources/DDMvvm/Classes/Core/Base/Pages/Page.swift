//
//  Page.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa
import PureLayout

open class Page<VM: IPageViewModel>: UIViewController, IView {
  
  /// Request to update status bar content color
  public var statusBarStyle: UIStatusBarStyle = .default {
    didSet { setNeedsStatusBarAppearanceUpdate() }
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return statusBarStyle
  }
  
  /// Request to update status bar hidden state
  public var statusBarHidden: Bool = false {
    didSet { setNeedsStatusBarAppearanceUpdate() }
  }
  
  open override var prefersStatusBarHidden: Bool {
    return statusBarHidden
  }
  
  private var _viewModel: VM?
  public var viewModel: VM? {
    get { return _viewModel }
    set {
      _viewModel = newValue
      viewModelChanged()
    }
  }
  
  public var anyViewModel: Any? {
    get { return _viewModel }
    set { viewModel = newValue as? VM }
  }
  
  public private(set) var backButton: UIBarButtonItem?
  private var backActionSubscription: Disposable?
  
  public var enableBackButton: Bool = false {
    didSet {
      if enableBackButton {
        if let backButton = backButtonFactory().create() {
          navigationItem.leftBarButtonItem = backButton
          
          // Handle tap action
          backActionSubscription?.dispose()
          backActionSubscription = backButton.rx.tap
            .subscribe(onNext: { [weak self] in
              self?.onBack()
            })
        }
      } else {
        navigationItem.leftBarButtonItem = nil
        backActionSubscription?.dispose()
      }
    }
  }
  
  public let navigationService: INavigationService = DependencyManager.shared.getService()
  
  public init(viewModel: VM? = nil) {
    _viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit { destroy() }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    initialize()
    viewModelChanged()
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel?.rxViewState.accept(.willAppear)
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel?.rxViewState.accept(.didAppear)
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel?.rxViewState.accept(.willDisappear)
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel?.rxViewState.accept(.didDisappear)
    
    if isMovingFromParent { destroy() }
  }
  
  /**
   Subclasses override this method to create its own back button on navigation bar.
   
   This method allows subclasses to create custom back button. To create the default back button, use global configurations `DDConfigurations.backButtonFactory`
   */
  open func backButtonFactory() -> Factory<UIBarButtonItem?> {
    Factory { nil }
  }
  
  /**
   Subclasses override this method to initialize UIs.
   
   This method is called in `viewDidLoad`. So try not to use `viewModel` property if you are
   not sure about it
   */
  open func initialize() {}
  
  /**
   Subclasses override this method to create data binding between view and viewModel.
   
   This method always happens, so subclasses should check if viewModel is nil or not. For example:
   ```
   guard let viewModel = viewModel else { return }
   ```
   */
  open func bindViewAndViewModel() {}
  
  /**
   Subclasses override this method to remove all things related to `DisposeBag`.
   */
  open override func destroy() {
    super.destroy()
    cleanBags()
    viewModel?.destroy()
  }
  
  /**
   Subclasses override this method to create custom back action for back button.
   
   By default, this will call pop action in navigation or dismiss in modal
   */
  @objc open func onBack() {
    navigationService.pop()
  }
}






