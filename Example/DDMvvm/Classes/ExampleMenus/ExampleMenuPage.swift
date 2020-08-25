//
//  ExampleMenuPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

enum SingleSection {
    case main
}

class ExampleMenuPage: ListPage<ExampleMenuPageViewModel> {

    override func initialize() {
        // super will pin our tableView to view edges
        // remove this if we want to custom tableView layout
        super.initialize()
        
        let count = navigationController?.viewControllers.count ?? 0
        if count > 1 {
            enableBackButton = true
        }
        
        tableView.estimatedRowHeight = 200
        tableView.register(ExampleMenuCell.self, forCellReuseIdentifier: ExampleMenuCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
    }
    
    override func cellIdentifier(_ cellViewModel: ExampleMenuCellViewModel) -> String {
        return ExampleMenuCell.identifier
    }
    
    override func selectedItemDidChange(_ cellViewModel: ExampleMenuCellViewModel) {
        if let indexPath = viewModel?.rxSelectedIndex.value {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

class ExampleMenuPageViewModel: ListViewModel<MenuModel, SingleSection, ExampleMenuCellViewModel> {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        let models = getMenuModels()
        itemsSource.update { snapshot in
            snapshot.appendSections([.main])
            snapshot.appendItems(models.toCellViewModels())
        }
        
        // set page title
        rxPageTitle.accept(model?.title ?? "")
    }
    
    override func selectedItemDidChange(_ cellViewModel: ExampleMenuCellViewModel) {
        if let page = pageToNavigate(cellViewModel) {
            navigationService.push(to: page)
        }
    }
    
    func getMenuModels() -> [MenuModel] {
        return []
    }
    
    func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        return nil
    }
}

/// Menu for home page
class HomeMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func react() {
        super.react()
        
        rxPageTitle.accept("DDMvvm Examples")
    }
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "MVVM Examples", desc: "Examples about different ways to use base classes Page, ListPage and CollectionPage."),
            MenuModel(withTitle: "Data Binding Examples", desc: "Examples about how to use data binding."),
            MenuModel(withTitle: "Service Injection Examples", desc: "Examples about how to create a service and register it; how to inject to our ViewModel."),
            MenuModel(withTitle: "Transition Examples", desc: "Examples about how to create a custom transitioning animation and apply it."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            page = ExampleMenuPage(viewModel: MvvmMenuPageViewModel(model: cellViewModel.model))
            
        case 1:
            page = ExampleMenuPage(viewModel: DataBindingMenuPageViewModel(model: cellViewModel.model))
            
        case 2: ()
            
        case 3:
            page = ExampleMenuPage(viewModel: TransitionMenuPageViewModel(model: cellViewModel.model))
            
        default: ()
        }
        
        return page
    }
}

/// Menu for data binding examples
class DataBindingMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "One-way, Two-way and Action Binding", desc: "How to setup data binding between ViewModel and View"),
            MenuModel(withTitle: "Custom Control with Data Binding", desc: "How to create a control with two-way binding property."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = DataBindingExamplePageViewModel(model: cellViewModel.model)
            page = DataBindingExamplePage(viewModel: vm)
            
        case 1:
            let vm = CustomControlExamplePageViewModel(model: cellViewModel.model)
            page = CustomControlExamplePage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}

/// Menu for transition examples
class TransitionMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "Transition in NavigationPage", desc: ""),
            MenuModel(withTitle: "Transition using modal presentation", desc: ""),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = NavigationTransitionExamplePageViewModel(model: cellViewModel.model)
            page = NavigationTransitionExamplePage(viewModel: vm)
            
        case 1:
            let vm = NavigationTransitionExamplePageViewModel(model: cellViewModel.model, usingModal: true)
            page = NavigationTransitionExamplePage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}

/// Menu for MVVM examples
class MvvmMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "ListPage Examples", desc: "Demostration on how to use ListPage"),
            MenuModel(withTitle: "CollectionPage Examples", desc: "Demostration on how to use CollectionPage"),
            MenuModel(withTitle: "Advanced Example 1", desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"),
            MenuModel(withTitle: "Advanced Example 2", desc: "An advanced example on using Search Bar to search images on Flickr."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = TPExampleMenuPageViewModel(model: cellViewModel.model)
            page = ExampleMenuPage(viewModel: vm)
            
        case 1:
            let vm = CPExampleMenuPageViewModel(model: cellViewModel.model)
            page = ExampleMenuPage(viewModel: vm)
            
        case 2:
            let vm = ContactListPageViewModel(model: cellViewModel.model)
            page = ContactListPage(viewModel: vm)
            
        case 3:
            /*
             Register for JsonService injection
             
             For real project, this should be call on AppDelegate. For now, as an example project,
             I may want to use different base url for different examples
             */
            DependencyManager.shared.registerService(Factory<IJsonService> {
                JsonService(baseUrl: "https://api.flickr.com/services/rest")
            })
            
            let vm = FlickrSearchPageViewModel(model: cellViewModel.model)
            page = FlickrSearchPage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}

/// Menu for demostration of list page
class TPExampleMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "Simple ListPage", desc: "A simple ListPage which has one cell identifier."),
            MenuModel(withTitle: "ListPage with section", desc: "A simple ListPage with section header and multiple cell identifiers."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = SimpleListPageViewModel(model: cellViewModel.model)
            page = SimpleListPage(viewModel: vm)
            
        case 1:
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            page = SectionListPage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}

/// Menu for demostration of collection page
class CPExampleMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "Simple CollectionPage", desc: "A simple CollectionPage which has one cell identifier."),
            MenuModel(withTitle: "CollectionPage with section", desc: "A simple CollectionPage with section header and multiple cell identifiers."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = SimpleListPageViewModel(model: cellViewModel.model)
            page = SimpleCollectionPage(viewModel: vm)
            
        case 1:
            let vm = SectionListPageViewModel(model: cellViewModel.model)
            page = SectionCollectionPage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}






