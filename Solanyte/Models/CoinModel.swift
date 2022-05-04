//
//  CoinModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 10.11.21.
//

// Coingecko API info
/* Coinbase API
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h
 */

// MARK: - CoinModel
class CoinModel: Identifiable, Codable {
  var id, symbol, name: String
  var image: String? = ""
  var currentPrice: Double? = 0
  var marketCap: Double? = 0
  var marketCapRank: Double? = 0
  var fullyDilutedValuation: Double? = 0
  var totalVolume: Double? = 0
  var high24H: Double? = 0
  var low24H: Double? = 0
  var marketCapChangePercentage24H: Double? = 0
  var marketCapChange24H: Double? = 0
  var priceChangePercentage24H: Double? = 0
  var priceChange24H: Double? = 0
  var ath: Double? = 0
  var maxSupply: Double? = 0
  var totalSupply: Double? = 0
  var circulatingSupply: Double? = 0
  var athChangePercentage: Double? = 0
  var athDate: String? = ""
  var atlChangePercentage: Double? = 0
  var atl: Double? = 0
  var atlDate: String? = ""
  var lastUpdated: String? = ""
  var sparklineIn7D: SparklineIn7D? = nil
  var priceChangePercentage24HInCurrency: Double? = 0
  var currentHoldings: Double? = 0
  var mintAddress: String? = ""
  
  init(
    id: String,
    symbol: String,
    name: String,
    image: String?,
    currentPrice: Double? = nil,
    marketCap: Double? = nil,
    marketCapRank: Double? = nil,
    fullyDilutedValuation: Double? = nil,
    totalVolume: Double? = nil,
    high24H: Double? = nil,
    low24H: Double? = nil,
    priceChange24H: Double? = nil,
    priceChangePercentage24H: Double? = nil,
    marketCapChange24H: Double? = nil,
    marketCapChangePercentage24H: Double? = nil,
    circulatingSupply: Double? = nil,
    totalSupply: Double? = nil,
    maxSupply: Double? = nil,
    ath: Double? = nil,
    athChangePercentage: Double? = nil,
    athDate: String? = nil,
    atl: Double? = nil,
    atlChangePercentage: Double? = nil,
    atlDate: String? = nil,
    lastUpdated: String? = nil,
    sparklineIn7D: SparklineIn7D? = nil,
    priceChangePercentage24HInCurrency: Double? = nil,
    currentHoldings: Double? = nil,
    mintAddress: String? = nil
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
    self.mintAddress = mintAddress
  }
  
  init(coinDetailModel cdm: CoinDetailModel, currentHoldings: Double? = 0) {
    self.id = cdm.id
    self.symbol = cdm.symbol
    self.name = cdm.name
    self.image = cdm.image?.small ?? ""
    self.currentPrice = cdm.marketData.currentPrice?["usd"]
    self.marketCap = cdm.marketData.marketCap?["usd"]
    self.marketCapRank = Double(cdm.marketData.marketCapRank ?? 0)
    self.fullyDilutedValuation = nil
    self.totalVolume = cdm.marketData.totalVolume?["usd"]
    self.high24H = cdm.marketData.high24H?["usd"]
    self.low24H = cdm.marketData.low24H?["usd"]
    self.priceChange24H = cdm.marketData.priceChange24H
    self.priceChangePercentage24H = cdm.marketData.priceChangePercentage24H
    self.marketCapChange24H = Double(cdm.marketData.marketCapChange24H ?? 0)
    self.marketCapChangePercentage24H = cdm.marketData.marketCapChangePercentage24H
    self.circulatingSupply = cdm.marketData.circulatingSupply
    self.totalSupply = cdm.marketData.totalSupply
    self.maxSupply = 0.0
    self.ath = cdm.marketData.ath?["usd"]
    self.athChangePercentage = cdm.marketData.athChangePercentage?["usd"]
    self.athDate = cdm.marketData.athDate?["usd"]
    self.atl = cdm.marketData.atl?["usd"]
    self.atlChangePercentage = cdm.marketData.atlChangePercentage?["usd"]
    self.atlDate = cdm.marketData.atlDate?["usd"]
    self.lastUpdated = cdm.marketData.lastUpdated
    self.sparklineIn7D = SparklineIn7D(price: cdm.marketData.sparkline7D?.price ?? [])
    self.priceChangePercentage24HInCurrency = cdm.marketData.priceChangePercentage24HInCurrency?["usd"]
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
  
  func updateHoldingsAndMintAddress(currentHoldings: Double, mintAddress: String?) -> CoinModel {
    return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: currentHoldings, mintAddress: mintAddress)
  }
  
  var currentHoldingsValue: Double {
    (currentHoldings ?? 0) * (currentPrice ?? 0)
  }
  
  var rank: Int {
    Int(marketCapRank ?? 0)
  }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
  var price: [Double]?
}

struct CoinModelFactory {
  static func custom(id: String, symbol: String, name: String, currentHoldings: Double = 0.0, image: String = "") -> CoinModel {
    return CoinModel(id: id, symbol: symbol, name: name, image: image, currentHoldings: currentHoldings)
  }
}
