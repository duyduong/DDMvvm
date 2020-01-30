//
//  CALayerExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/30/20.
//

import UIKit

public extension CALayer {
    
    var image: UIImage? {
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
