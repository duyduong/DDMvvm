//
//  UIImageViewExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import Alamofire

public struct NetworkImage {
    
    var placeholder: UIImage?
    var url: URL?
    var completion: ((DataResponse<UIImage>) -> Void)?
    
    init() {}
    
    init(withURL url: URL?) {
        self.url = url
    }
    
    init(withURL url: URL?, placeholder: UIImage?) {
        self.url = url
        self.placeholder = placeholder
    }
    
    init(withURL url: URL?, completion: ((DataResponse<UIImage>) -> Void)?) {
        self.url = url
        self.completion = completion
    }
    
}








