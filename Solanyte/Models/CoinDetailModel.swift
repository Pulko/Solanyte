//
//  CoinDetailModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

/*
 URL: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 
 Response:
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "asset_platform_id": null,
 "platforms": {
 "": ""
 },
 "block_time_in_minutes": 10,
 "hashing_algorithm": "SHA-256",
 "categories": [
 "Cryptocurrency"
 ],
 "public_notice": null,
 "additional_notices": [],
 "description": {
 "en": "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the <a href=\"https://www.coingecko.com/en?hashing_algorithm=SHA-256\">SHA-256</a> hashing algorithm with an average transaction confirmation time of 10 minutes. Miners today are mining Bitcoin using ASIC chip dedicated to only mining Bitcoin, and the hash rate has shot up to peta hashes.\r\n\r\nBeing the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as <a href=\"https://www.coingecko.com/en/coins/litecoin\">Litecoin</a>, <a href=\"https://www.coingecko.com/en/coins/peercoin\">Peercoin</a>, <a href=\"https://www.coingecko.com/en/coins/primecoin\">Primecoin</a>, and so on.\r\n\r\nThe cryptocurrency then took off with the innovation of the turing-complete smart contract by <a href=\"https://www.coingecko.com/en/coins/ethereum\">Ethereum</a> which led to the development of other amazing projects such as <a href=\"https://www.coingecko.com/en/coins/eos\">EOS</a>, <a href=\"https://www.coingecko.com/en/coins/tron\">Tron</a>, and even crypto-collectibles such as <a href=\"https://www.coingecko.com/buzz/ethereum-still-king-dapps-cryptokitties-need-1-billion-on-eos\">CryptoKitties</a>."
 },
 "links": {
 "homepage": [
 "http://www.bitcoin.org",
 "",
 ""
 ],
 "blockchain_site": [
 "https://blockchair.com/bitcoin/",
 "https://btc.com/",
 "https://btc.tokenview.com/",
 "",
 "",
 "",
 "",
 "",
 "",
 ""
 ],
 "official_forum_url": [
 "https://bitcointalk.org/",
 "",
 ""
 ],
 "chat_url": [
 "",
 "",
 ""
 ],
 "announcement_url": [
 "",
 ""
 ],
 "twitter_screen_name": "bitcoin",
 "facebook_username": "bitcoins",
 "bitcointalk_thread_identifier": null,
 "telegram_channel_identifier": "",
 "subreddit_url": "https://www.reddit.com/r/Bitcoin/",
 "repos_url": {
 "github": [
 "https://github.com/bitcoin/bitcoin",
 "https://github.com/bitcoin/bips"
 ],
 "bitbucket": []
 }
 },
 "image": {
 "thumb": "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png?1547033579",
 "small": "https://assets.coingecko.com/coins/images/1/small/bitcoin.png?1547033579",
 "large": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
 },
 "country_origin": "",
 "genesis_date": "2009-01-03",
 "sentiment_votes_up_percentage": 56.33,
 "sentiment_votes_down_percentage": 43.67,
 "market_cap_rank": 1,
 "coingecko_rank": 2,
 "coingecko_score": 80.359,
 "developer_score": 98.876,
 "community_score": 70.91,
 "liquidity_score": 100.198,
 "public_interest_score": 0,
 "public_interest_stats": {
 "alexa_rank": 9440,
 "bing_matches": null
 },
 "status_updates": [],
 "last_updated": "2022-01-08T17:07:27.747Z"
 }
 */

import Foundation

// MARK: - CoinDetailModel
struct CoinDetailModel: Identifiable, Codable {
  let id, symbol, name: String
  let blockTimeInMinutes: Int?
  let hashingAlgorithm: String?
  let description: Description?
  let links: Links?
  let image: CoinImage?
  let marketData: MarketData
  
  enum CodingKeys: String, CodingKey {
    case id, symbol, name, description, links, image
    case blockTimeInMinutes = "block_time_in_minutes"
    case hashingAlgorithm = "hashing_algorithm"
    case marketData = "market_data"
  }
  
  var readableDescription: String {
    return description?.en?.removingHTMLOccurencies ?? ""
  }
}

// MARK: - Links
struct Links: Codable {
  let homepage: [String]?
  let subredditURL: String?
  
  enum CodingKeys: String, CodingKey {
    case homepage
    case subredditURL = "subreddit_url"
  }
}

// MARK: - Image
struct CoinImage: Codable {
  let thumb, small, large: String
}

// MARK: - Description
struct Description: Codable {
  let en: String?
}

// MARK: - MarketData
struct MarketData: Codable {
  let currentPrice: [String: Double]?
  let ath, athChangePercentage: [String: Double]?
  let athDate: [String: String]?
  let atl, atlChangePercentage: [String: Double]?
  let atlDate: [String: String]?
  let marketCap: [String: Double]?
  let marketCapRank: Int?
  let totalVolume: [String: Double]?
  let high24H, low24H: [String: Double]?
  let priceChange24H, priceChangePercentage24H, priceChangePercentage7D, priceChangePercentage14D: Double?
  let priceChangePercentage30D, priceChangePercentage60D, priceChangePercentage200D, priceChangePercentage1Y: Double?
  let marketCapChange24H: Double?
  let marketCapChangePercentage24H: Double?
  let priceChange24HInCurrency, priceChangePercentage1HInCurrency, priceChangePercentage24HInCurrency, priceChangePercentage7DInCurrency: [String: Double]?
  let priceChangePercentage14DInCurrency, priceChangePercentage30DInCurrency, priceChangePercentage60DInCurrency, priceChangePercentage200DInCurrency: [String: Double]?
  let priceChangePercentage1YInCurrency, marketCapChange24HInCurrency, marketCapChangePercentage24HInCurrency: [String: Double]?
  let totalSupply: Double?
  let circulatingSupply: Double?
  let sparkline7D: Sparkline7D?
  let lastUpdated: String?
  
  enum CodingKeys: String, CodingKey {
    case currentPrice = "current_price"
    case ath
    case athChangePercentage = "ath_change_percentage"
    case athDate = "ath_date"
    case atl
    case atlChangePercentage = "atl_change_percentage"
    case atlDate = "atl_date"
    case marketCap = "market_cap"
    case marketCapRank = "market_cap_rank"
    case totalVolume = "total_volume"
    case high24H = "high_24h"
    case low24H = "low_24h"
    case priceChange24H = "price_change_24h"
    case priceChangePercentage24H = "price_change_percentage_24h"
    case priceChangePercentage7D = "price_change_percentage_7d"
    case priceChangePercentage14D = "price_change_percentage_14d"
    case priceChangePercentage30D = "price_change_percentage_30d"
    case priceChangePercentage60D = "price_change_percentage_60d"
    case priceChangePercentage200D = "price_change_percentage_200d"
    case priceChangePercentage1Y = "price_change_percentage_1y"
    case marketCapChange24H = "market_cap_change_24h"
    case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
    case priceChange24HInCurrency = "price_change_24h_in_currency"
    case priceChangePercentage1HInCurrency = "price_change_percentage_1h_in_currency"
    case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    case priceChangePercentage7DInCurrency = "price_change_percentage_7d_in_currency"
    case priceChangePercentage14DInCurrency = "price_change_percentage_14d_in_currency"
    case priceChangePercentage30DInCurrency = "price_change_percentage_30d_in_currency"
    case priceChangePercentage60DInCurrency = "price_change_percentage_60d_in_currency"
    case priceChangePercentage200DInCurrency = "price_change_percentage_200d_in_currency"
    case priceChangePercentage1YInCurrency = "price_change_percentage_1y_in_currency"
    case marketCapChange24HInCurrency = "market_cap_change_24h_in_currency"
    case marketCapChangePercentage24HInCurrency = "market_cap_change_percentage_24h_in_currency"
    case totalSupply = "total_supply"
    case circulatingSupply = "circulating_supply"
    case sparkline7D = "sparkline_7d"
    case lastUpdated = "last_updated"
  }
}

// MARK: - Sparkline7D
struct Sparkline7D: Codable {
  let price: [Double]?
}
