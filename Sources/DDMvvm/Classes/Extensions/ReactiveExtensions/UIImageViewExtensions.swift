//
//  UIImageViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Alamofire
import AlamofireImage
import RxCocoa
import RxSwift
import UIKit

public struct NetworkImage {
  public let url: URL?
  public let placeholder: UIImage?
  public let completion: ((AFIDataResponse<UIImage>) -> Void)?

  public init(
    withURL url: URL? = nil,
    placeholder: UIImage? = nil,
    completion: ((AFIDataResponse<UIImage>) -> Void)? = nil
  ) {
    self.url = url
    self.placeholder = placeholder
    self.completion = completion
  }
}

public extension Reactive where Base: UIImageView {
  /// Simple binder for `NetworkImage`
  var networkImage: Binder<NetworkImage> { networkImage() }

  /// Optional image transition and completion that allow View to do more action after completing download image
  func networkImage(
    _ imageTransition: UIImageView.ImageTransition = .crossDissolve(0.25),
    completion: ((AFIDataResponse<UIImage>) -> Void)? = nil
  ) -> Binder<NetworkImage> {
    Binder(base) { view, image in
      if let placeholder = image.placeholder {
        view.image = placeholder
      }

      if let url = image.url {
        view.af.setImage(withURL: url, imageTransition: imageTransition, completion: { response in
          /// callback for ViewModel to handle after completion
          image.completion?(response)

          /// callback for View to handle after completion
          completion?(response)
        })
      }
    }
  }
}
