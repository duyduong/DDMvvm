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
                destroy()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set {
            if let vm = newValue as? VM {
                viewModel = vm
            }
        }
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
        
        // setup default local hud
        localHud = LocalHud(addedToView: view)
        
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
        disposeBag = DisposeBag()
        hudBag = DisposeBag()
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
    
    private func bindLocalHud() {
        hudBag = DisposeBag()
        
        if let viewModel = viewModel, let localHud = localHud {
            viewModel.rxShowInlineLoader ~> localHud.rx.show => hudBag
            viewModel.rxShowInlineLoader.subscribe(onNext: localHudToggled) => hudBag
        }
    }
    
    private func viewModelChanged() {
        bindLocalHud()
        bindViewAndViewModel()
        viewModel?.react()
    }
}






