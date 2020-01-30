//
//  CGSizeExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 1/30/20.
//

import Foundation

public extension CGSize {
    
    static func square(_ size: CGFloat) -> CGSize {
        return CGSize(width: size, height: size)
    }
}
