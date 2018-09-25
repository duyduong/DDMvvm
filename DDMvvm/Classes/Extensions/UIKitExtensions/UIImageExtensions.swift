//
//  UIKitExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIImage {
    
    // create image from mono color
    static func from(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return from(color: color, withSize: size)
    }
    
    // create image from mono color with specific size
    static func from(color: UIColor, withSize size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        path.addClip()
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}








