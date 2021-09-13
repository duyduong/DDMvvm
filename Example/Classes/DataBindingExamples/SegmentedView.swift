//
//  SegmentedView.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DDMvvm
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: SegmentedView {

  var selectedIndex: ControlProperty<Int> {
    return UIControl.toProperty(control: base, getter: { segmentedView in
      segmentedView.selectedIndex
    }, setter: { segmentedView, value in
      if value != segmentedView.selectedIndex {
        segmentedView.selectedIndex = value
      }
    })
  }
}

class SegmentedView: AbstractControlView {

  let titles: [String]
  var apportionsSegmentWidthsByContent: Bool {
    didSet { updateDistribution() }
  }

  private var shadowView: UIView!
  private var stackView: UIStackView!
  private var indicatorView: UIView!

  private var verticalConstraint: NSLayoutConstraint!

  var selectedIndex = 0 {
    didSet {
      if selectedIndex < buttons.count {
        buttons.forEach { $0.isSelected = false }
        let selectedBtn = buttons[selectedIndex]
        selectedBtn.isSelected = true
        moveIndicator(relativeTo: selectedBtn)
      }

      sendActions(for: .valueChanged)
    }
  }

  private var buttons: [UIButton] = []

  private let indicatorWidth: CGFloat = 30

  var leadingConst: NSLayoutConstraint!

  init(withTitles titles: [String], apportionsSegmentWidthsByContent: Bool = true) {
    self.titles = titles
    self.apportionsSegmentWidthsByContent = apportionsSegmentWidthsByContent
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    titles = []
    apportionsSegmentWidthsByContent = true
    super.init(coder: aDecoder)
  }

  override func setupView() {
    snp.makeConstraints {
      $0.height.equalTo(50)
    }

    shadowView = UIView()
    shadowView.backgroundColor = .white
    addSubview(shadowView)
    shadowView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets.only(bottom: 4))
    }

    stackView = UIStackView()
    stackView.alignment = .fill
    updateDistribution()
    shadowView.addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    for title in titles {
      let btn = UIButton(type: .custom)
      buttons.append(btn)
      btn.setTitle(title.uppercased(), for: .normal)
      btn.setTitleColor(.fromHex("666666"), for: .normal)
      btn.setTitleColor(.fromHex("2895ff"), for: .highlighted)
      btn.setTitleColor(.fromHex("2895ff"), for: .selected)
      btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
      btn.contentEdgeInsets = .all(15)
      btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
      stackView.addArrangedSubview(btn)
    }

    indicatorView = UIView()
    indicatorView.backgroundColor = .fromHex("2895ff")
    indicatorView.cornerRadius = 1
    addSubview(indicatorView)
    indicatorView.snp.makeConstraints {
      $0.width.equalTo(indicatorWidth)
      $0.height.equalTo(3)
    }
    if let first = buttons.first {
      indicatorView.snp.makeConstraints {
        $0.centerX.equalToSuperview().offset(15)
        $0.centerY.equalTo(first.snp.centerY)
      }

      first.isSelected = true
    } else {
      indicatorView.isHidden = true
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    setShadow(offset: CGSize(width: 0, height: -2), color: .gray, opacity: 0.05, blur: 1)
    shadowView.setShadow(offset: CGSize(width: 0, height: 3), color: .gray, opacity: 0.4, blur: 3)
  }

  @objc func buttonPressed(_ sender: UIButton) {
    if let index = buttons.firstIndex(of: sender) {
      selectedIndex = index
    }
  }

  private func moveIndicator(relativeTo selectedBtn: UIButton, animated: Bool = true) {
    let center = selectedBtn.center
    let moveCenter = CGPoint(x: center.x, y: center.y + 15 + indicatorView.frame.height / 2)

    if animated {
      UIView.animate(withDuration: 0.25, animations: {
        self.indicatorView.center = moveCenter
      }) { _ in
        self.updateVerticalConstraint(to: selectedBtn)
      }
    } else {
      updateVerticalConstraint(to: selectedBtn)
    }
  }

  private func updateVerticalConstraint(to selectedBtn: UIButton) {
    indicatorView.snp.updateConstraints {
      $0.centerY.equalTo(selectedBtn.snp.centerY)
    }
  }

  private func updateDistribution() {
    if apportionsSegmentWidthsByContent {
      stackView.distribution = .fillProportionally
    } else {
      stackView.distribution = .fillEqually
    }
  }
}
