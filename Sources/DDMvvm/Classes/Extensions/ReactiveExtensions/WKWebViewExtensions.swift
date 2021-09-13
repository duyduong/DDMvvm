//
//  WKWebViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

public extension Reactive where Base: WKWebView {
  var url: Binder<URL?> {
    Binder(base) { view, url in
      guard let url = url else { return }
      view.stopLoading()
      view.load(URLRequest(url: url))
    }
  }
}
