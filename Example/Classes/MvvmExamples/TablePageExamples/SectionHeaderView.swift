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
    base.addBtn.rx.tap.map { [base] in base.section }
  }
}

class SectionHeaderView: UIView, IDestroyable {
  private let titleLbl = UILabel()
  let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  
  var section: SectionList {
    didSet { updateTitle() }
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
    toolbar.tintColor = .black
    addSubview(toolbar)
    toolbar.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLbl.textColor = .black
    let titleItem = UIBarButtonItem(customView: titleLbl)
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let items = [titleItem, spaceItem, addBtn]
    toolbar.items = items
    
    updateTitle()
  }
  
  private func updateTitle() {
    guard case let .single(title) = section else { return }
    titleLbl.text = title
  }
}
