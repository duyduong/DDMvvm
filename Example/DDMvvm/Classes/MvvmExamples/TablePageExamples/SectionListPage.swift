//
//  SectionListPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm
import Action
import RxSwift
import RxCocoa

class SectionListPage: ListPage<SectionListPageViewModel>, UITableViewDelegate {
    
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    let sortBtn = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)

    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        navigationItem.rightBarButtonItems = [addBtn, sortBtn]
        
        tableView.delegate = self
        tableView.register(SectionTextCell.self, forCellReuseIdentifier: SectionTextCell.identifier)
        tableView.register(SectionImageCell.self, forCellReuseIdentifier: SectionImageCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
        sortBtn.rx.bind(to: viewModel.sortAction, input: ())
    }
    
    // Based on type to return correct identifier for cells
    override func cellIdentifier(_ cellViewModel: SuperCellViewModel) -> String {
        if cellViewModel is SectionImageCellViewModel {
            return SectionImageCell.identifier
        }
        
        return SectionTextCell.identifier
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let vm = viewModel?.itemsSource.snapshot?.sectionIdentifiers[section] {
            let headerView = SectionHeaderView(viewModel: vm)
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel?.itemsSource.snapshot?.sectionIdentifiers[section] {
            return 30
        }
        
        return 0
    }
}

class SectionListPageViewModel: ListViewModel<Any, SectionHeaderViewViewModel, SuperCellViewModel> {
    
    let imageUrls = [
        "https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3cP_SZVm5g43t4U8slThjjp6v1dGoUyfPd6ncEvVQQG1LzDl",
        "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&h=350"
    ]
    
    lazy var addAction: Action<Void, Void> = Action() { .just(self.add()) }
    lazy var sortAction: Action<Void, Void> = Action() { .just(self.sort()) }
    
    var tmpBag: DisposeBag?
    
    override func react() {
        itemsSource.snapshotChanged
            .compactMap {
                return $0?.snapshot.sectionIdentifiers.map {
                    $0.addAction.executionObservables.switchLatest()
                }
            }
            .subscribe(onNext: { obs in
                self.tmpBag = DisposeBag()
                Observable.merge(obs).subscribe(onNext: self.addCell) => self.tmpBag
            }) => disposeBag
    }
    
    private func addCell(_ vm: SectionHeaderViewViewModel) {
        let randomIndex = Int.random(in: 0...1)
        
        // randomly show text cell or image cell
        if randomIndex == 0 {
            // ramdom image from imageUrls
            let index = Int.random(in: 0..<imageUrls.count)
            let url = imageUrls[index]
            let model = SectionImageModel(imageUrl: URL(string: url)!)
            
            itemsSource.update { snapshot in
                snapshot.appendItems([SectionImageCellViewModel(model: model)], toSection: vm)
            }
        } else {
            itemsSource.update { snapshot in
                snapshot.appendItems([
                    SectionTextCellViewModel(model: SectionTextModel(title: "Just a text cell title", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."))
                ], toSection: vm)
            }
        }
    }
    
    // add section
    private func add() {
        let count = itemsSource.snapshot?.numberOfSections ?? 0
        let vm = SectionHeaderViewViewModel(model: SimpleModel(title: "Section title #\(count + 1)"))
        itemsSource.update { snapshot in
            snapshot.appendSections([vm])
        }
    }
    
    private func sort() {
        let count = itemsSource.snapshot?.numberOfSections ?? 0
        guard count > 0 else { return }
        
        let section = Int.random(in: 0..<count)
        guard let vm = itemsSource.snapshot?.sectionIdentifiers[section] else { return }
        itemsSource.update { snapshot in
            var currentItems = snapshot.itemIdentifiers(inSection: vm)
            currentItems = currentItems.sorted(by: { (cvm1, cvm2) -> Bool in
                if let m1 = cvm1.model as? NumberModel, let m2 = cvm2.model as? NumberModel {
                    return m1.number < m2.number
                }
                return false
            })
            
            snapshot.appendItems(currentItems, toSection: vm)
        }
    }
}








