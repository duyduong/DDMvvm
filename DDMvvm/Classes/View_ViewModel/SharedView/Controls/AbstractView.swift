//
//  AbstractView.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

class AbstractView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {}
    
}

class AbstractControlView: UIControl {
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {}
    
}
