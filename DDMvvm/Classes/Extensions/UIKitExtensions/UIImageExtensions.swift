//
//  UIKitExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension UIImage {
    
    /// Create image from mono color
    public static func from(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return from(color: color, withSize: size)
    }
    
    /// Create image from mono color with specific size and corner radius
    public static func from(color: UIColor, withSize size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        path.addClip()
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}








