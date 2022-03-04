//
//  SortManager.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 26.02.22.
//

import Foundation

enum SortOption {
  case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}

class SortManager {
  static func filterCoins(coins: inout [CoinModel], filter: Bool) {
    if (filter) {
      coins = coins.filter { $0.currentHoldingsValue > 0 }
    }
  }
  
  static func sortCoins(coins: inout [CoinModel], sort: SortOption = .holdings) {
    switch sort {
    case .price:
      coins.sort {
        if let first = $0.currentPrice, let second = $1.currentPrice {
          return first > second
        }
        return false
      }
    case .priceReversed:
      coins.sort {
        if let first = $0.currentPrice, let second = $1.currentPrice {
          return first < second
        }
        return false
      }
    case .rank:
      coins.sort { $0.rank > $1.rank }
    case .rankReversed:
      coins.sort { $0.rank < $1.rank }
    case .holdings:
      coins.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
    case .holdingsReversed:
      coins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
    }
  }
}
