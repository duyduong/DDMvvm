//
//  CALayerExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/30/20.
//

import UIKit

public extension CALayer {
    
    func toImage(_ isOpaque: Bool = false) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
