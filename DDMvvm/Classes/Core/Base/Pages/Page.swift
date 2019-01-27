//
//  Page.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import PureLayout

open class Page<VM: IViewModel>: UIViewController, IView, ITransitionView {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    private var hudBag: DisposeBag? = DisposeBag()
    
    public var animatorDelegate: AnimatorDelegate?
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            if _viewModel != newValue {
                cleanUp()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? VM }
    }
    
    public var backButton: UIBarButtonItem?
    public var localHud: LocalHud? {
        didSet { bindLocalHud() }
    }
    
    private lazy var backAction: Action<Void, Void> = {
        return Action() { .just(self.onBack()) }
    }()
    
    public var enableBackButton: Bool = false {
        didSet {
            if enableBackButton {
                backButton = DDConfigurations.backButtonFactory.create()
                navigationItem.leftBarButtonItem = backButton
                backButton?.rx.bind(to: backAction, input: ())
            } else {
                navigationItem.leftBarButtonItem = nil
                backButton?.rx.unbindAction()
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // setup default local hud
        let localHud = DDConfigurations.localHudFactory.create()
        view.addSubview(localHud)
        localHud.setupView()
        self.localHud = localHud
        
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
    }
    
    open func initialize() {}
    
    open func bindViewAndViewModel() {}
    
    open func localHudToggled(_ value: Bool) {}
    
    open func destroy() {
        cleanUp()
    }
    
    open func onBack() {
        navigationService.pop()
    }
    
    private func cleanUp() {
        disposeBag = DisposeBag()
        hudBag = DisposeBag()
        viewModel?.destroy()
    }
    
    private func bindLocalHud() {
        hudBag = DisposeBag()
        
        if let viewModel = viewModel, let localHud = localHud {
            let shared = viewModel.rxShowInlineLoader.distinctUntilChanged().share()
            shared ~> localHud.rx.show => hudBag
            shared.subscribe(onNext: localHudToggled) => hudBag
        }
    }
    
    private func viewModelChanged() {
        bindLocalHud()
        bindViewAndViewModel()
        viewModel?.react()
    }
}






