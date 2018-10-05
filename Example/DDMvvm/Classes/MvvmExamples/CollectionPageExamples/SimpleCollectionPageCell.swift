//
//  SimpleCollectionPageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class SimpleCollectionPageCell: CollectionCell<SimpleListPageCellViewModel> {
    
    static let identifier = "SimpleCollectionPageCell"
    
    let titleLbl = UILabel()
    
    override func initialize() {
        cornerRadius = 5
        backgroundColor = .black
        
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 0
        contentView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .equally(5))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
}
