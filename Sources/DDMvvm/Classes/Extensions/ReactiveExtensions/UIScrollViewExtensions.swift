//
//  UIScrollViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxSwift
import UIKit

public extension Reactive where Base: UIScrollView {
  func endReach(_ distance: CGFloat) -> Observable<Void> {
    Observable.create { [base] observer in
      base.rx.contentOffset.subscribe(onNext: { offset in
        let scrollViewHeight = base.frame.size.height
        let scrollContentSizeHeight = base.contentSize.height
        let scrollOffset = offset.y

        let scrollSize = scrollOffset + scrollViewHeight

        // at the bottom
        if scrollSize >= scrollContentSizeHeight - distance {
          observer.onNext(())
        }
      })
    }
  }
}
