//
//  UIImageViewExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

public struct NetworkImage {
    
    var url: URL? = nil
    var placeholder: UIImage? = nil
    var completion: ((DataResponse<UIImage>) -> Void)? = nil
    
    init(withURL url: URL? = nil, placeholder: UIImage? = nil, completion: ((DataResponse<UIImage>) -> Void)? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.completion = completion
    }
}

extension Reactive where Base: UIImageView {
    
    public var networkImage: Binder<NetworkImage> {
        return Binder(self.base) { view, image in
            if let placeholder = image.placeholder {
                view.image = placeholder
            }
            
            if let url = image.url {
                view.af_setImage(withURL: url, imageTransition: .crossDissolve(0.25), completion: image.completion)
            }
        }
    }
}








