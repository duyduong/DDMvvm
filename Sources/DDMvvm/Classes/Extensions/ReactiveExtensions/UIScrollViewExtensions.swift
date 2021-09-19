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
    base.rx.contentOffset.flatMap { [base] contentOffset -> Observable<Void> in
      let scrollViewHeight = base.frame.size.height
      let scrollContentSizeHeight = base.contentSize.height
      let scrollOffset = contentOffset.y
      let scrollSize = scrollOffset + scrollViewHeight
      if scrollSize >= scrollContentSizeHeight - distance {
        return .just(())
      }
      return .empty()
    }
  }
}
