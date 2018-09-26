//
//  DEViewController.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/6/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import PureLayout

open class DDPage<VM: IViewModel>: UIViewController, IView, UIGestureRecognizerDelegate {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            disposeBag = DisposeBag()
            _viewModel?.destroy()
            
            _viewModel = newValue
            
            viewModelChanged()
        }
    }
    
    var backButton: UIBarButtonItem?
    
    var loaderView: InlineLoaderView!
    
    private lazy var backAction: Action<Void, Void> = {
        return Action() {
            self.onBack()
            return .just(())
        }
    }()
    
    public var enableBackButton: Bool = false {
        didSet {
            if enableBackButton {
                backButton = createBackButton()
                navigationItem.leftBarButtonItem = backButton
                backButton?.rx.bind(to: backAction, input: ())
            } else {
                navigationItem.leftBarButtonItem = nil
                backButton?.rx.unbindAction()
            }
        }
    }
    
    public let navigationService: INavigationService
    
    public init(viewModel: VM? = nil, navigationService: INavigationService? = nil) {
        self._viewModel = viewModel
        self.navigationService = navigationService ?? DependencyManager.shared.getService()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.navigationService = DependencyManager.shared.getService()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Controller life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loaderView = InlineLoaderView()
        view.addSubview(loaderView)
        loaderView.autoCenterInSuperview()
        
        initialize()
        viewModelChanged()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewState.accept(.willAppear)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewState.accept(.didAppear)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewState.accept(.willDisappear)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewState.accept(.didDisappear)
    }
    
    // MARK: - For subclass to override
    
    open func initialize() {}
    
    open func bindViewAndViewModel() {}
    
    open func onLoading(_ value: Bool) {}
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    // MARK: - Back button setup
    
    open func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.setTitleTextAttributes([.font: Font.system.normal(withSize: 18)], for: .normal)
        button.title = "\u{2190}"
        return button
    }
    
    open func onBack() {
        navigationService.pop()
    }
    
    // MARK: - Private
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        
        // binding for loading
        if let viewModel = viewModel {
            viewModel.react()
            viewModel.showInlineLoader ~> loaderView.rx.show => disposeBag
            viewModel.showInlineLoader.subscribe(onNext: onLoading) => disposeBag
        }
    }
    
}






