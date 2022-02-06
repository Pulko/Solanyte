//
//  MarketDataModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//


import Foundation

// MARK: - Welcome
struct GlobalData: Codable {
  let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
  let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
  let marketCapChangePercentage24HUsd: Double
  
  enum CodingKeys: String, CodingKey {
    case totalMarketCap = "total_market_cap"
    case totalVolume = "total_volume"
    case marketCapPercentage = "market_cap_percentage"
    case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
  }
  
  private func getValueByKey(
    _ object: Dictionary<String, Double>,
    key: String,
    callback: (_ value: Double) -> String = { "\($0)" }
  ) -> String {
    if let item = object.first(where: { $0.key == key }) {
      return callback(item.value)
    }
    
    return ""
  }
  
  var marketCap: String {
    getValueByKey(totalMarketCap, key: "usd") { $0.formattedWithAbbreviations() }
  }
  
  var volume: String {
    getValueByKey(totalVolume, key: "usd") { $0.formattedWithAbbreviations() }
  }
  
  var btcDominance: String {
    getValueByKey(marketCapPercentage, key: "btc") { $0.asPercentString() }
  }
}
