//
//  FlickerImageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class FlickrImageCell: CollectionCell<FlickrImageCellViewModel> {
    
    static let identifier = "FlickrImageCell"
    
    let imageView = UIImageView()
    let titleLbl = UILabel()
    
    override func initialize() {
        contentView.cornerRadius = 7
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.autoPinEdgesToSuperviewEdges()
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        contentView.addSubview(titleView)
        titleView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        titleLbl.font = Font.system.normal(withSize: 15)
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 2
        titleView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .equally(5))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxImage ~> imageView.rx.networkImage => disposeBag
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
}

class FlickrImageCellViewModel: CellViewModel<FlickrPhotoModel> {
    
    let rxImage = BehaviorRelay(value: NetworkImage())
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        rxImage.accept(NetworkImage(withURL: model?.imageUrl, placeholder: UIImage.from(color: .black)))
        rxTitle.accept(model?.title)
    }
}









