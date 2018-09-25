//
//  WKWebViewExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 2/8/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

extension Reactive where Base: WKWebView {
    
    var url: Binder<URL?> {
        return Binder(self.base) { view, url in
            if let url = url {
                view.stopLoading()
                view.load(URLRequest(url: url))
            }
        }
    }
    
}
