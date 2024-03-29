//
//  FlickerSearchPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Alamofire
import DDMvvm
import RxCocoa
import RxSwift
import UIKit

class FlickrSearchPage: CollectionPage<FlickrSearchPageViewModel> {
  let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
  let indicatorView = UIActivityIndicatorView(style: .gray)

  let loadMoreView = UIView()
  let loadMoreIndicator = UIActivityIndicatorView(style: .whiteLarge)

  let padding: CGFloat = 5

  override func initialize() {
    super.initialize()

    // setup search bar
    indicatorView.hidesWhenStopped = true
    searchBar.placeholder = "Search for Flickr images"
    navigationItem.titleView = searchBar

    // setup load more
    loadMoreView.isHidden = true
    loadMoreView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
    view.addSubview(loadMoreView)
    loadMoreView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
    }

    loadMoreIndicator.hidesWhenStopped = false
    loadMoreIndicator.startAnimating()
    loadMoreView.addSubview(loadMoreIndicator)
    loadMoreIndicator.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(10)
    }

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

    viewModel.rxSearchText <~> searchBar.rx.text => disposeBag

    // toggle show/hide indicator next to search bar
    viewModel.rxIsSearching ~> indicatorView.rx.isAnimating => disposeBag

    // toggle load more indicator when scroll to bottom
    viewModel.rxIsLoadingMore
      .observe(on: Scheduler.shared.mainScheduler)
      .subscribe(onNext: { value in
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
          guard let self = self else { return }
          if value {
            self.loadMoreView.transform = .identity
          } else {
            self.loadMoreView.transform = CGAffineTransform(
              translationX: 0,
              y: self.loadMoreView.frame.height
            )
          }
        })
      }) => disposeBag

    viewModel.alertRelay.flatMap { [weak self] alert -> Observable<Int> in
      guard let self = self else { return .empty() }
      return self.schedule(alert: alert).asObservable()
    }.subscribe() => disposeBag

    // call out load more when reach to end of collection view
    collectionView.rx.endReach(50).subscribe(onNext: { [weak viewModel] in
      viewModel?.loadMore()
    }) => disposeBag
  }

  // this method is required
  override func cellIdentifier(_ item: FlickrSearchResponse.Photo) -> String {
    FlickrImageCell.identifier
  }
}

extension FlickrSearchPage: Alertable {
  typealias Alert = DefaultAlert
}

extension FlickrSearchPage: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
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
}

class FlickrSearchPageViewModel: ListViewModel<SingleSection, FlickrSearchResponse.Photo> {
  @Injected var jsonService: IJsonService

  let rxSearchText = BehaviorRelay<String?>(value: nil)
  let rxIsSearching = BehaviorRelay(value: false)
  let rxIsLoadingMore = BehaviorRelay(value: false)
  let alertRelay = PublishRelay<DefaultAlert>()

  var page = 1
  let perPage = 20
  var done = false

  var tmpBag: DisposeBag?

  var params: [String: Any] {
    [
      "method": "flickr.photos.search",
      "api_key": "891774493ea5183f9ddba6ccec09a3bb", // please provide your API key
      "format": "json",
      "nojsoncallback": 1,
      "page": page,
      "per_page": perPage,
      "text": rxSearchText.value ?? ""
    ]
  }

  override func initialize() {
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
      .flatMap { [weak self] text -> Observable<[FlickrSearchResponse.Photo]> in
        guard let self = self else { return .empty() }
        if !text.isNilOrEmpty {
          let obs: Single<FlickrSearchResponse> = self.jsonService.get(
            path: "",
            params: self.params,
            parameterEncoding: URLEncoding.queryString
          )
          return obs.asObservable().map(self.prepareSources)
        }

        return .just([])
      }
      .subscribe(onNext: { [weak self] items in
        guard let self = self else { return }
        self.itemsSource.update(animated: true) { snapshot in
          var newSnapshot = DataSourceSnapshot()
          newSnapshot.appendSections([.main])
          newSnapshot.appendItems(items)
          snapshot = newSnapshot
        }
        self.rxIsSearching.accept(false)
      }) => disposeBag
  }

  fileprivate func loadMore() {
    let numberOfItems = itemsSource.snapshot.numberOfItems
    if numberOfItems <= 0 || done || rxIsLoadingMore.value { return }

    tmpBag = DisposeBag()

    rxIsLoadingMore.accept(true)
    page += 1

    let obs: Single<FlickrSearchResponse> = jsonService.get(
      path: "",
      params: params,
      parameterEncoding: URLEncoding.queryString
    )
    obs.map(prepareSources)
      .subscribe { event in
        switch event {
        case let .success(photos):
          self.itemsSource.update(animated: true) { snapshot in
            snapshot.appendItems(photos)
          }
          
        case let .failure(error):
          print(">>> Load image error", error)
          break
        }
        self.rxIsLoadingMore.accept(false)
      } => tmpBag
  }

  private func prepareSources(_ response: FlickrSearchResponse) -> [FlickrSearchResponse.Photo] {
    if response.stat == .fail {
      let message = response.message ?? "Failed to search on Flickr"
      alertRelay.accept(.ok(title: "Error", message: message))
    }
    
    if response.photos.page >= response.photos.pages {
      done = true
    }
    
    return response.photos.photo
  }
}
