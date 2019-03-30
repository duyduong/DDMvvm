//
//  ContactCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class ContactCell: TableCell<ContactCellViewModel> {

    let avatarIv = UIImageView()
    let nameLbl = UILabel()
    let phoneLbl = UILabel()
    
    override func initialize() {
        let paddingView = UIView()
        contentView.addSubview(paddingView)
        paddingView.autoPinEdgesToSuperviewEdges(with: .all(5))
        
        avatarIv.image = UIImage(named: "default-contact")
        paddingView.addSubview(avatarIv)
        avatarIv.autoSetDimensions(to: CGSize(width: 64, height: 64))
        avatarIv.autoPinEdge(toSuperviewEdge: .top)
        avatarIv.autoPinEdge(toSuperviewEdge: .leading)
        avatarIv.autoPinEdge(toSuperviewEdge: .bottom)
        
        let infoView = UIView()
        paddingView.addSubview(infoView)
        infoView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        infoView.autoPinEdge(.leading, to: .trailing, of: avatarIv, withOffset: 8)
        
        nameLbl.numberOfLines = 0
        nameLbl.font = Font.system.bold(withSize: 17)
        infoView.addSubview(nameLbl)
        nameLbl.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        phoneLbl.numberOfLines = 0
        phoneLbl.font = Font.system.normal(withSize: 15)
        infoView.addSubview(phoneLbl)
        phoneLbl.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        phoneLbl.autoPinEdge(.top, to: .bottom, of: nameLbl)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxName ~> nameLbl.rx.text => disposeBag
        viewModel.rxPhone ~> phoneLbl.rx.text => disposeBag
    }
}

class ContactCellViewModel: CellViewModel<ContactModel> {
    
    let rxName = BehaviorRelay<String?>(value: nil)
    let rxPhone = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        modelChanged()
    }
    
    override func modelChanged() {
        rxName.accept(model?.name)
        rxPhone.accept(model?.phone)
    }
}









