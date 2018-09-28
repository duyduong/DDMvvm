//
//  Page.swift
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

open class Page<VM: IViewModel>: UIViewController, IView, ITransionView {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    private var loadingBag: DisposeBag? = DisposeBag()
    
    public var animatorDelegate: AnimatorDelegate?
    
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
    
    public var backButton: UIBarButtonItem?
    public var loaderView: InlineLoaderView?
    
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
    
    public init(viewModel: VM? = nil) {
        _viewModel = viewModel
        navigationService = DependencyManager.shared.getService()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        navigationService = DependencyManager.shared.getService()
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        attachInlineLoaderView()
        
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
    
    public func attachInlineLoaderView(at position: ComponentViewPosition = .center) {
        // remove older loader view if have
        loadingBag = DisposeBag()
        self.loaderView?.removeFromSuperview()
        
        // attach new loader view
        let loaderView = InlineLoaderView.attach(to: view, position: position)
        self.loaderView = loaderView
        
        if let viewModel = viewModel {
            viewModel.showInlineLoader ~> loaderView.rx.show => loadingBag
            viewModel.showInlineLoader.subscribe(onNext: inlineLoadingChanged) => loadingBag
        }
    }
    
    open func initialize() {}
    
    open func bindViewAndViewModel() {}
    
    open func inlineLoadingChanged(_ value: Bool) {}
    
    open func destroy() {
        disposeBag = DisposeBag()
        loadingBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.setTitleTextAttributes([.font: Font.system.normal(withSize: 18)], for: .normal)
        button.title = "\u{2190}"
        return button
    }
    
    open func onBack() {
        navigationService.pop()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        viewModel?.react()
    }
}






