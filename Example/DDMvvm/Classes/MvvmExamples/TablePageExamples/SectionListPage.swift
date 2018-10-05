//
//  SectionListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Action
import RxSwift
import DDMvvm

class SectionListPage: ListPage<SectionListPageViewModel> {
    
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.register(SectionTextCell.self, forCellReuseIdentifier: SectionTextCell.identifier)
        tableView.register(SectionImageCell.self, forCellReuseIdentifier: SectionImageCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    // Based on type to return correct identifier for cells
    override func cellIdentifier(_ cellViewModel: SuperCellViewModel) -> String {
        if cellViewModel is SectionImageCellViewModel {
            return SectionImageCell.identifier
        }
        
        return SectionTextCell.identifier
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let vm = viewModel?.itemsSource[section].key as? SectionHeaderViewViewModel {
            let headerView = SectionHeaderView(viewModel: vm)
            return headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel?.itemsSource[section].key as? SectionHeaderViewViewModel {
            return 30
        }
        
        return 0
    }
}

class SectionListPageViewModel: ListViewModel<Model, SuperCellViewModel> {
    
    let imageUrls = [
        "https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3cP_SZVm5g43t4U8slThjjp6v1dGoUyfPd6ncEvVQQG1LzDl",
        "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&h=350"
    ]
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    var tmpBag: DisposeBag?
    
    override func react() {
        itemsSource.asObservable()
            .subscribe(onNext: { sectionLists in
                self.tmpBag = DisposeBag()
                
                for sectionList in sectionLists {
                    if let cvm = sectionList.key as? SectionHeaderViewViewModel {
                        cvm.addAction
                            .executionObservables
                            .switchLatest()
                            .subscribe(onNext: self.addCell) => self.tmpBag
                    }
                }
            }) => disposeBag
    }
    
    private func addCell(_ vm: SectionHeaderViewViewModel) {
        if let sectionIndex = itemsSource.indexForSection(withKey: vm) {
            let randomIndex = Int.random(in: 0...1)
            
            // randomly show text cell or image cell
            if randomIndex == 0 {
                // ramdom image from imageUrls
                let index = Int.random(in: 0..<imageUrls.count)
                let url = imageUrls[index]
                let model = SectionImageModel(withUrl: url)
                
                itemsSource.append(SectionImageCellViewModel(model: model), to: sectionIndex)
            } else {
                itemsSource.append(SectionTextCellViewModel(model: SectionTextModel(withTitle: "Just a text cell title", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")), to: sectionIndex)
            }
        }
    }
    
    // add section
    private func add() {
        let vm = SectionHeaderViewViewModel(model: SimpleModel(withTitle: "Section title #\(itemsSource.count + 1)"))
        itemsSource.appendSection(SectionList<SuperCellViewModel>(vm))
    }
}










