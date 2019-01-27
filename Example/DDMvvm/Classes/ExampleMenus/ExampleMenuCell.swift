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
        let paddingView = UIView()
        contentView.addSubview(paddingView)
        paddingView.autoPinEdgesToSuperviewEdges(with: .equally(5))
        
        titleLbl.numberOfLines = 0
        titleLbl.font = Font.system.bold(withSize: 17)
        paddingView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        descLbl.numberOfLines = 0
        descLbl.font = Font.system.normal(withSize: 15)
        paddingView.addSubview(descLbl)
        descLbl.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        descLbl.autoPinEdge(.top, to: .bottom, of: titleLbl)
        
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









