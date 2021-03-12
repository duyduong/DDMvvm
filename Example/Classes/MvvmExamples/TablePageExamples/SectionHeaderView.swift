//
//  SectionHeaderView.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DDMvvm

class SectionHeaderView: View<SectionHeaderViewViewModel> {
    
    let titleLbl = UILabel()
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func initialize() {
        let toolbar = UIToolbar()
        addSubview(toolbar)
        toolbar.autoPinEdgesToSuperviewEdges(with: .zero)
        
        let titleItem = UIBarButtonItem(customView: titleLbl)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [titleItem, spaceItem, addBtn]
        toolbar.items = items
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        addBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel?.addPressed()
        }) => disposeBag
    }
}

class SectionHeaderViewViewModel: CellViewModel<SimpleModel> {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    fileprivate let publisher = PublishSubject<SectionHeaderViewViewModel>()
    lazy var itemAddedObservable = publisher.asObservable()
    
    override func react() {
        rxTitle.accept(model?.title)
    }
    
    func addPressed() {
        publisher.onNext(self)
    }
}






