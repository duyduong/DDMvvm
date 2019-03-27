//
//  UIImageViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

public struct NetworkImage {
    
    public private(set) var url: URL? = nil
    public private(set) var placeholder: UIImage? = nil
    public private(set)var completion: ((DataResponse<UIImage>) -> Void)? = nil
    
    public init(withURL url: URL? = nil, placeholder: UIImage? = nil, completion: ((DataResponse<UIImage>) -> Void)? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.completion = completion
    }
}

extension Reactive where Base: UIImageView {
    
    public var networkImage: Binder<NetworkImage> {
        return networkImage()
    }
    
    // allow UI to set completion
    public func networkImage(_ imageTransition: UIImageView.ImageTransition = .crossDissolve(0.25), _ completion: ((DataResponse<UIImage>) -> Void)? = nil) -> Binder<NetworkImage> {
        return Binder(base) { view, image in
            if let placeholder = image.placeholder {
                view.image = placeholder
            }
            
            if let url = image.url {
                view.af_setImage(withURL: url, imageTransition: .crossDissolve(0.25), completion: { response in
                    image.completion?(response)
                    completion?(response)
                })
            }
        }
    }
}








