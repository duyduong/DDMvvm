//
//  ICell.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 11/09/2021.
//

import Foundation

protocol CellConfigurable {
  func setData(data: Any)
}

public protocol ICell {
  associatedtype CellData
  var data: CellData? { get set }
}
