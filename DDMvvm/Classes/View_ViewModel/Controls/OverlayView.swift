//
//  OverlayView.swift
//  phimbo
//
//  Created by Dao Duy Duong on 10/22/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

class OverlayView: AbstractControlView {
    
    let tapGesture = UITapGestureRecognizer()
    
    override func setupView() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        addGestureRecognizer(tapGesture)
    }
    
    static func addToPage(_ page: UIViewController) -> OverlayView {
        let overlayView = OverlayView()
        page.view.addSubview(overlayView)
        overlayView.autoPinEdgesToSuperviewEdges()
        
        return overlayView
    }

}
