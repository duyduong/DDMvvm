//
//  FlickerSearchPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Action
import DDMvvm

class FlickrSearchPage: CollectionPage<FlickrSearchPageViewModel> {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let padding: CGFloat = 5

    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        // setup search bar
        searchBar.placeholder = "Search for Flickr images"
        indicatorView.hidesWhenStopped = true
        
        navigationItem.titleView = searchBar
        
        // setup collection view
        collectionView.register(FlickrImageCell.self, forCellWithReuseIdentifier: FlickrImageCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let textField = searchBar.subviews[0].subviews.last as? UITextField {
            textField.rightView = indicatorView
            textField.rightViewMode = .always
        }
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.rxSearchText <~> searchBar.rx.text => disposeBag
        viewModel.rxIsSearching.subscribe(onNext: { value in
            if value {
                self.indicatorView.startAnimating()
            } else {
                self.indicatorView.stopAnimating()
            }
        }) => disposeBag
        
        collectionView.rx.endReach.subscribe(onNext: {
            viewModel.loadMoreAction.execute(())
        }) => disposeBag
    }
    
    override func cellIdentifier(_ cellViewModel: FlickrImageCellViewModel) -> String {
        return FlickrImageCell.identifier
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        
        let numOfCols: CGFloat
        if viewWidth <= 375 {
            numOfCols = 2
        } else if viewWidth <= 568 {
            numOfCols = 3
        } else if viewWidth <= 768 {
            numOfCols = 4
        } else {
            numOfCols = 5
        }
        
        let contentWidth = viewWidth - ((numOfCols + 1) * padding)
        let width = contentWidth / numOfCols
        
        return CGSize(width: width, height: 4 * width / 3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .equally(padding)
    }
}

class FlickrSearchPageViewModel: ListViewModel<MenuModel, FlickrImageCellViewModel> {
    
    // Json service injection
    let jsonService: IJsonService = DependencyManager.shared.getService()
    
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxIsSearching = BehaviorRelay<Bool>(value: false)
    
    var page = 1
    var done = false
    var isLoadingMore = false
    
    var tmpBag: DisposeBag?
    
    var params: [String: Any] {
        return [
            "method": "flickr.photos.search",
            "api_key": "c22d48140f5ca304816ef08963e4e4fe",
            "format": "json",
            "nojsoncallback": 1,
            "page": page,
            "per_page": 20,
            "text": rxSearchText.value ?? ""
        ]
    }
    
    lazy var loadMoreAction: Action<Void, Void> = {
        return Action() { .just(self.loadMore()) }
    }()
    
    override func react() {
        // Whenever text changed
        rxSearchText
            .do(onNext: { text in
                self.tmpBag = nil // stop current load more if any
                self.page = 1 // reset to page 1
                self.done = false // reset done state
                
                if !text.isNilOrEmpty {
                    self.rxIsSearching.accept(true)
                }
            })
            .debounce(0.5, scheduler: Scheduler.shared.mainScheduler)
            .flatMap { text -> Observable<[FlickrItemModel]> in
                if !text.isNilOrEmpty {
                    let obs: Single<FlickrSearchResponse> = self.jsonService.get("", params: self.params, parameterEncoding: URLEncoding.queryString)
                    return obs.asObservable()
                        .catchErrorJustReturn(FlickrSearchResponse())
                        .map { $0.photos }
                }
                
                return .just([])
            }
            .subscribe(onNext: { items in
                self.itemsSource.reset([items.toCellViewModels()])
                self.rxIsSearching.accept(false)
            }) => disposeBag
    }
    
    private func loadMore() {
        tmpBag = DisposeBag()
        
        if itemsSource.countElements() <= 0 || done || isLoadingMore { return }
        
        isLoadingMore = true
        page += 1
        
        let obs: Single<FlickrSearchResponse> = jsonService.get("", params: params, parameterEncoding: URLEncoding.queryString)
        obs.map { $0.photos }.subscribe(onSuccess: { items in
            if items.count == 0 {
                self.done = true
            }
            self.itemsSource.append(items.toCellViewModels())
            self.isLoadingMore = false
        }, onError: { error in
            self.isLoadingMore = false
        }) => tmpBag
    }
}











