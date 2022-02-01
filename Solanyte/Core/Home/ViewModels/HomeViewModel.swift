//
//  HomeViewModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 15.11.21.
//

import Foundation
import SwiftUI
import UIKit
import Combine

enum SortOption {
  case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}

class HomeViewModel: ObservableObject {
  @Published var portfolioCoins: [CoinModel] = []
  @Published var isLoading: Bool = false
  @Published var statistics: [StatisticModel] = []
  
  private let portfolioDataService = PortfolioDataService()
  private let marketDataService = MarketDataService()
  private var cancellables = Set<AnyCancellable>()
  
  var isListFull: Bool = false
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    // update portfolio coins
    portfolioDataService.$savedCoins
      .sink { [weak self] (returnedCoins) in
        self?.portfolioCoins = returnedCoins.uniqued() // updates portfolio coins and triggers next subscriber
        self?.isLoading = false // once coins are update, loading is over
      }
      .store(in: &cancellables)

    // updates market data and portfolio
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] (statistics) in
        self?.statistics = statistics // updates statistics
        self?.isLoading = false // once stats are update, loading is over
      }
      .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    marketDataService.reload()
    portfolioDataService.reload()
    HapticManager.notification(type: .success)
  }
  
  private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    
    guard let data = marketDataModel else { return stats }
    
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "Volume", value: data.volume)
    
    stats.append(contentsOf: [
      marketCap,
      volume,
    ])
    
    return stats
  }
}


