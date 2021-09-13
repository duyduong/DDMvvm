//
//  SectionHeaderView.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import RxSwift
import UIKit



extension Reactive where Base: SectionHeaderView {
  var addSectionObservable: Observable<SectionList> {
    base.addBtn.rx.tap.map { [weak base] in
      guard let base = base else {
        return .init(title: "")
      }
      return base.section
    }
  }
}

class SectionHeaderView: UIView, IDestroyable {
  private let titleLbl = UILabel()
  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  
  var section: SectionList {
    didSet { update() }
  }
  
  init(section: SectionList) {
    self.section = section
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Use init(section:)")
  }
  
  private func setupView() {
    let toolbar = UIToolbar()
    addSubview(toolbar)
    toolbar.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    let titleItem = UIBarButtonItem(customView: titleLbl)
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let items = [titleItem, spaceItem, addBtn]
    toolbar.items = items
  }
  
  private func update() {
    titleLbl.text = section.title
  }
}
