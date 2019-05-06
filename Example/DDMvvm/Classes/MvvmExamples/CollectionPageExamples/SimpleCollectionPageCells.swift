//
//  SimpleCollectionPageCells.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm

class CPTextCell: CollectionCell<SectionTextCellViewModel> {
    
    let titleLbl = UILabel()
    let descLbl = UILabel()
    
    override func initialize() {
        cornerRadius = 5
        backgroundColor = .black
        
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 0
        titleLbl.font = Font.system.bold(withSize: 17)
        
        descLbl.textColor = .white
        descLbl.numberOfLines = 0
        descLbl.font = Font.system.normal(withSize: 15)
        
        let layout = StackLayout().direction(.vertical).children([
            titleLbl,
            descLbl
        ])
        contentView.addSubview(layout)
        layout.autoPinEdgesToSuperviewEdges(with: .all(5))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
}

class CPImageCell: CollectionCell<SectionImageCellViewModel> {
    
    let netImageView = UIImageView()
    
    override func initialize() {
        cornerRadius = 5
        
        netImageView.contentMode = .scaleAspectFill
        netImageView.clipsToBounds = true
        contentView.addSubview(netImageView)
        netImageView.autoPinEdgesToSuperviewEdges()
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxImage ~> netImageView.rx.networkImage => disposeBag
    }
}
