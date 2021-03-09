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

class FlickrSearchPage: CollectionPage<FlickrSearchPageViewModel>, UICollectionViewDelegateFlowLayout {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    let indicatorView = UIActivityIndicatorView(style: .gray)
    
    let loadMoreView = UIView()
    let loadMoreIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let padding: CGFloat = 5

    override func initialize() {
        super.initialize()
        
        enableBackButton = true
        
        // setup search bar
        indicatorView.hidesWhenStopped = true
        searchBar.placeholder = "Search for Flickr images"
        navigationItem.titleView = searchBar
        
        // setup load more
        loadMoreView.isHidden = true
        loadMoreView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        view.addSubview(loadMoreView)
        loadMoreView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        loadMoreIndicator.hidesWhenStopped = false
        loadMoreIndicator.startAnimating()
        loadMoreView.addSubview(loadMoreIndicator)
        loadMoreIndicator.autoAlignAxis(toSuperviewAxis: .vertical)
        loadMoreIndicator.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        loadMoreIndicator.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        
        // setup collection view
        collectionView.delegate = self
        collectionView.register(FlickrImageCell.self, forCellWithReuseIdentifier: FlickrImageCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let textField = searchBar.subviews[0].subviews.last as? UITextField {
            textField.rightView = indicatorView
            textField.rightViewMode = .always
        }
        
        loadMoreView.transform = CGAffineTransform(translationX: 0, y: loadMoreView.frame.height)
        loadMoreView.isHidden = false
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.rxSearchText <~> searchBar.rx.text => disposeBag
        
        // toggle show/hide indicator next to search bar
        viewModel.rxIsSearching.subscribe(onNext: { value in
            if value {
                self.indicatorView.startAnimating()
            } else {
                self.indicatorView.stopAnimating()
            }
        }) => disposeBag
        
        // toggle load more indicator when scroll to bottom
        viewModel.rxIsLoadingMore.subscribe(onNext: { value in
            UIView.animate(withDuration: 0.5, animations: {
                if value {
                    self.loadMoreView.transform = .identity
                } else {
                    self.loadMoreView.transform = CGAffineTransform(translationX: 0, y: self.loadMoreView.frame.height)
                }
            })
        }) => disposeBag
        
        // call out load more when reach to end of collection view
        collectionView.rx.endReach(50).subscribe(onNext: {
            viewModel.loadMoreAction.execute(())
        }) => disposeBag
    }
    
    // this method is required
    override func cellIdentifier(_ cellViewModel: FlickrImageCellViewModel) -> String {
        return FlickrImageCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .all(padding)
    }
}

class FlickrSearchPageViewModel: ListViewModel<MenuModel, SingleSection, FlickrImageCellViewModel> {
    
    // Json service injection
    let jsonService: IJsonService = DependencyManager.shared.getService()
    
    // Alert service injection
    let alertService: IAlertService = DependencyManager.shared.getService()
    
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxIsSearching = BehaviorRelay<Bool>(value: false)
    let rxIsLoadingMore = BehaviorRelay<Bool>(value: false)
    
    var page = 1
    let perPage = 20
    var done = false
    
    var tmpBag: DisposeBag?
    
    var params: [String: Any] {
        return [
            "method": "flickr.photos.search",
            "api_key": "b31f0f4d78f96a1315d1d25f07ec09c1", // please provide your API key
            "format": "json",
            "nojsoncallback": 1,
            "page": page,
            "per_page": perPage,
            "text": rxSearchText.value ?? ""
        ]
    }
    
    lazy var loadMoreAction: Action<Void, Void> = Action() { .just(self.loadMore()) }
    
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
            .debounce(.milliseconds(500), scheduler: Scheduler.shared.mainScheduler)
            .flatMap { text -> Observable<[FlickrImageCellViewModel]> in
                if !text.isNilOrEmpty {
                    let obs: Single<FlickrSearchResponse> = self.jsonService.get(path: "", params: self.params, parameterEncoding: URLEncoding.queryString)
                    return obs.asObservable().map(self.prepareSources)
                }
                
                return .just([])
            }
            .subscribe(onNext: { cvms in
                self.itemsSource.update { snapshot in
                    if snapshot.numberOfSections == 0 {
                        snapshot.appendSections([.main])
                    }
                    
                    snapshot.appendItems(cvms)
                }
                self.rxIsSearching.accept(false)
            }) => disposeBag
    }
    
    private func loadMore() {
        let numberOfItems = itemsSource.snapshot?.numberOfItems ?? 0
        if numberOfItems <= 0 || done || rxIsLoadingMore.value { return }
        
        tmpBag = DisposeBag()
        
        rxIsLoadingMore.accept(true)
        page += 1
        
        let obs: Single<FlickrSearchResponse> = jsonService.get(path: "", params: params, parameterEncoding: URLEncoding.queryString)
        obs.map(prepareSources).subscribe(onSuccess: { cvms in
            self.itemsSource.update { snapshot in
                if snapshot.numberOfSections == 0 {
                    snapshot.appendSections([.main])
                }
                
                snapshot.appendItems(cvms)
            }
            
            self.rxIsLoadingMore.accept(false)
        }, onFailure: { error in
            self.rxIsLoadingMore.accept(false)
        }) => tmpBag
    }
    
    private func prepareSources(_ response: FlickrSearchResponse) -> [FlickrImageCellViewModel] {
        if response.stat == .fail {
            let message = response.message ?? "Failed to search on Flickr"
            alertService.presentOkayAlert(title: "Error", message: "\(message)\nPlease be sure to provide your own API key from Flickr.")
        }
        
        if response.photos.page >= response.photos.pages {
            done = true
        }
        
        return response.photos.photo.map { FlickrImageCellViewModel(model: $0) }
    }
}











