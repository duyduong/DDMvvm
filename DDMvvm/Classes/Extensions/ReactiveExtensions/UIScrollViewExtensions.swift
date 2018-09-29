//
//  UIScrollViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift

extension Reactive where Base: UIScrollView {
    
    public var endReach: Observable<Void> {
        return Observable.create { observer in
            return self.base.rx.contentOffset.subscribe(onNext: { offset in
                let scrollViewHeight = self.base.frame.size.height
                let scrollContentSizeHeight = self.base.contentSize.height
                let scrollOffset = offset.y
                
                let scrollSize = scrollOffset + scrollViewHeight
                
                // at the bottom
                if scrollSize >= scrollContentSizeHeight - 50 {
                    observer.onNext(())
                }
            })
        }
    }
}
