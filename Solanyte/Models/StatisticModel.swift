//
//  StatisticModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

import Foundation

struct StatisticModel: Identifiable {
  let id = UUID().uuidString
  let title: String
  let value: String
  let percentChange: Double?
  
  init(title: String, value: String, percentChange: Double? = nil) {
    self.title = title
    self.value = value
    self.percentChange = percentChange
  }
}
