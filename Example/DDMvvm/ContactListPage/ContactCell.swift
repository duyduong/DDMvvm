//
//  ContactCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DDMvvm

class ContactCell: TableCell<ContactCellViewModel> {

    static let identifier = "ContactCell"
    
    private let iconView = UIImageView()
    private let titleLbl = UILabel()
    
    override func initialize() {
        titleLbl.numberOfLines = 0
        titleLbl.textColor = .black
        contentView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .equally(20))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.name ~> titleLbl.rx.text => disposeBag
    }
}

class ContactCellViewModel: CellViewModel<ContactModel> {
    
    let name = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        name.accept(model?.name)
    }
}




