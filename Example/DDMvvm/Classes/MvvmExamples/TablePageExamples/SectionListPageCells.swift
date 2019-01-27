//
//  SectionListPageCells.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class SectionTextCell: TableCell<SectionTextCellViewModel> {
    
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
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
}

class SectionTextCellViewModel: SuperCellViewModel {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let model = model as? SectionTextModel else { return }
        
        rxTitle.accept(model.title)
        rxDesc.accept(model.desc)
    }
}

class SectionImageCell: TableCell<SectionImageCellViewModel> {
    
    let netImageView = UIImageView()
    
    override func initialize() {
        netImageView.contentMode = .scaleAspectFill
        netImageView.clipsToBounds = true
        contentView.addSubview(netImageView)
        netImageView.autoMatch(.height, to: .width, of: netImageView, withMultiplier: 9/16.0)
        netImageView.autoPinEdgesToSuperviewEdges(with: .topBottom(10, leftRight: 15))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxImage ~> netImageView.rx.networkImage => disposeBag
    }
}

class SectionImageCellViewModel: SuperCellViewModel {
    
    let rxImage = BehaviorRelay(value: NetworkImage())
    
    override func react() {
        guard let model = model as? SectionImageModel else { return }
        
        rxImage.accept(NetworkImage(withURL: model.imageUrl, placeholder: UIImage.from(color: .lightGray)))
    }
}







