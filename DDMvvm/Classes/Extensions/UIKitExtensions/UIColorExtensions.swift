//
//  UIColorExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    public convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    public convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    public convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    public convenience init?(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "")
        guard let hex = hexString.toHex() else { return nil }
        self.init(hex: hex)
    }
    
    public static func fromHex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? UIColor.clear
    }

}










