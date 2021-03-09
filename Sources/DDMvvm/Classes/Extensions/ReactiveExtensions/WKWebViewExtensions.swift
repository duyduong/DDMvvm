//
//  WKWebViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

public extension Reactive where Base: WKWebView {
    
    var url: Binder<URL?> {
        return Binder(base) { view, url in
            if let url = url {
                view.stopLoading()
                view.load(URLRequest(url: url))
            }
        }
    }
}
