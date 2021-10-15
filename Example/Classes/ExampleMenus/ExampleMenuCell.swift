//
//  ExampleMenuCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class ExampleMenuCell: TableCell<ExampleMenuCellViewModel> {
    
    let titleLbl = UILabel()
    let descLbl = UILabel()
    
    override func initialize() {
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)
        
        descLbl.numberOfLines = 0
        descLbl.font = UIFont.preferredFont(forTextStyle: .body)
        
        let layout = StackLayout().direction(.vertical).children([
            titleLbl,
            descLbl
        ])
        contentView.addSubview(layout)
        layout.autoPinEdgesToSuperviewEdges(with: .all(5))
        
        accessoryType = .disclosureIndicator
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
}

class ExampleMenuCellViewModel: CellViewModel<MenuModel> {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        rxTitle.accept(model?.title)
        rxDesc.accept(model?.desc)
    }
}









