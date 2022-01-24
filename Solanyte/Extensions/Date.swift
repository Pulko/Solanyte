//
//  Date.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation

extension Date {
  init(coinGeckoString: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = formatter.date(from: coinGeckoString) ?? Date()
    
    self.init(timeInterval: 0, since: date) // original Date initializer
  }
  
  private var shortFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.dateFormat = "dd.MM.YYYY"
    
    return formatter
  }
  
  func asShortDateString() -> String {
    return shortFormatter.string(from: self)
  }
}
