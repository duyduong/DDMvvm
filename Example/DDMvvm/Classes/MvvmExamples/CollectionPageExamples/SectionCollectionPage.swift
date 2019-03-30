//
//  SectionCollectionPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Action
import DDMvvm

/*
 You can notice that, this page does not create own ViewModel, I reused the SectionListPageViewModel
 Even the cells, it reused SectionTextCellViewModel and SectionImageCellViewModel
 This should be the characteristic of ViewModel, decoupling with View
 */
class SectionCollectionPage: CollectionPage<TestPageViewModel> {

    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    let padding: CGFloat = 5
    
    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        navigationItem.rightBarButtonItem = addBtn
        
        (layout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
        collectionView.register(SectionHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SectionHeaderCell.identifier)
        collectionView.register(CPTextCell.self, forCellWithReuseIdentifier: CPTextCell.identifier)
        collectionView.register(CPImageCell.self, forCellWithReuseIdentifier: CPImageCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    // Based on cellViewModel type, we can return correct identifier for cells
    override func cellIdentifier(_ cellViewModel: SuperCellViewModel) -> String {
        if cellViewModel is SectionImageCellViewModel {
            return CPImageCell.identifier
        }
        
        return CPTextCell.identifier
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    /// Setup section header cell, each header cell will map with key from itemsSource
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath)
            
            // to set ViewModel for this cell, just casting to IAnyView and set anyViewModel property
            if let cell = cell as? IAnyView,
                let vm = viewModel?.itemsSource[indexPath.section].key as? SectionHeaderViewViewModel {
                cell.anyViewModel = vm
            }
            
            return cell
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let numOfCols: CGFloat = 2//collectionView.frame.width > collectionView.frame.height ? 2 : 1
        
        let contentWidth = viewWidth - ((numOfCols + 1) * padding)
        let width = contentWidth / numOfCols
        return CGSize(width: width, height: 9 * width / 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .all(padding)
    }
}
