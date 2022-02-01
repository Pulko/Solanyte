//
//  Array.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 27.01.22.
//

import Foundation

extension Array where Element: Hashable {
  func uniqued() -> Array {
    var buffer = Array()
    var added = Set<Element>()
  
    for elem in self {
      if !added.contains(elem) {
        buffer.append(elem)
        added.insert(elem)
      }
    }
    return buffer
  }
}

extension Array where Element: PortfolioEntity {
  func uniqued() -> Array {
    var buffer = Array()
    var added = Set<Element>()
  
    for elem in self {
      if !added.contains(where: { $0.coinID == elem.coinID }) {
        buffer.append(elem)
        added.insert(elem)
      }
    }
    return buffer
  }
}

extension Array where Element: CoinModel {
  func uniqued() -> Array {
    var buffer = Array()
  
    for elem in self {
      if buffer.first(where: { $0.id == elem.id }) == nil {
        buffer.append(elem)
      }
    }
    return buffer
  }
}
