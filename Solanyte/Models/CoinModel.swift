//
//  CoinModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 10.11.21.
//

// Coingecko API info
/* Coinbase API
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h
 */

// MARK: - CoinModel
class CoinModel: Identifiable, Codable {
  let id, symbol, name: String
  let image: String
  let currentPrice: Double
  let marketCap, marketCapRank, fullyDilutedValuation: Double?
  let totalVolume, high24H, low24H: Double?
  let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
  let circulatingSupply, totalSupply, maxSupply, ath: Double?
  let athChangePercentage: Double?
  let athDate: String?
  let atl, atlChangePercentage: Double?
  let atlDate: String?
  let lastUpdated: String?
  let sparklineIn7D: SparklineIn7D?
  let priceChangePercentage24HInCurrency: Double?
  let currentHoldings: Double?
  
  init(
    id: String,
    symbol: String,
    name: String,
    image: String,
    currentPrice: Double,
    marketCap: Double?,
    marketCapRank: Double?,
    fullyDilutedValuation: Double?,
    totalVolume: Double?,
    high24H: Double?,
    low24H: Double?,
    priceChange24H: Double?,
    priceChangePercentage24H: Double?,
    marketCapChange24H: Double?,
    marketCapChangePercentage24H: Double?,
    circulatingSupply: Double?,
    totalSupply: Double?,
    maxSupply: Double?,
    ath: Double?,
    athChangePercentage: Double?,
    athDate: String?,
    atl: Double?,
    atlChangePercentage: Double?,
    atlDate: String?,
    lastUpdated: String?,
    sparklineIn7D: SparklineIn7D?,
    priceChangePercentage24HInCurrency: Double?,
    currentHoldings: Double?
  ) {
    self.id = id
    self.symbol = symbol
    self.name = name
    self.image = image
    self.currentPrice = currentPrice
    self.marketCap = marketCap
    self.marketCapRank = marketCapRank
    self.fullyDilutedValuation = fullyDilutedValuation
    self.totalVolume = totalVolume
    self.high24H = high24H
    self.low24H = low24H
    self.priceChange24H = priceChange24H
    self.priceChangePercentage24H = priceChangePercentage24H
    self.marketCapChange24H = marketCapChange24H
    self.marketCapChangePercentage24H = marketCapChangePercentage24H
    self.circulatingSupply = circulatingSupply
    self.totalSupply = totalSupply
    self.maxSupply = maxSupply
    self.ath = ath
    self.athChangePercentage = athChangePercentage
    self.athDate = athDate
    self.atl = atl
    self.atlChangePercentage = atlChangePercentage
    self.atlDate = atlDate
    self.lastUpdated = lastUpdated
    self.sparklineIn7D = sparklineIn7D
    self.priceChangePercentage24HInCurrency = priceChangePercentage24HInCurrency
    self.currentHoldings = currentHoldings
  }
  
  enum CodingKeys: String, CodingKey {
    case id, symbol, name, image
    case currentPrice = "current_price"
    case marketCap = "market_cap"
    case marketCapRank = "market_cap_rank"
    case fullyDilutedValuation = "fully_diluted_valuation"
    case totalVolume = "total_volume"
    case high24H = "high_24h"
    case low24H = "low_24h"
    case priceChange24H = "price_change_24h"
    case priceChangePercentage24H = "price_change_percentage_24h"
    case marketCapChange24H = "market_cap_change_24h"
    case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
    case circulatingSupply = "circulating_supply"
    case totalSupply = "total_supply"
    case maxSupply = "max_supply"
    case ath
    case athChangePercentage = "ath_change_percentage"
    case athDate = "ath_date"
    case atl
    case atlChangePercentage = "atl_change_percentage"
    case atlDate = "atl_date"
    case lastUpdated = "last_updated"
    case sparklineIn7D = "sparkline_in_7d"
    case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    case currentHoldings
  }
  
  func updateHoldings (amount: Double) -> CoinModel {
    return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
  }
  
  var currentHoldingsValue: Double {
    (currentHoldings ?? 0) * currentPrice
  }
  
  var rank: Int {
    Int(marketCapRank ?? 0)
  }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
  let price: [Double]?
}
