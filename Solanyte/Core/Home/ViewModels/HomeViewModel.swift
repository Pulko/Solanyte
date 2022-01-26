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
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""
  @Published var statistics: [StatisticModel] = []
  @Published var sortOption: SortOption = .rank
  
  private let portfolioDataService = PortfolioDataService()
  private let marketDataService = MarketDataService()
  private let coinDataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  var isListFull: Bool = false
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {

    // updates all coins
    $searchText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] (allCoins) in
        self?.allCoins = allCoins  // updates all coins and triggers next subscriber
        
        if (allCoins.count % (self?.coinDataService.perPage)! > 0) {
          self?.isListFull = true
        }
      }
      .store(in: &cancellables)

    // update portfolio coins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolio)
      .sink { [weak self] (returnedCoins) in
        guard let self = self else { return }

        self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins) // updates portfolio coins and triggers next subscriber
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
    coinDataService.reload()
    marketDataService.reload()
    HapticManager.notification(type: .success)
  }
  
  func fetchMore() {
    isLoading = true
    coinDataService.fetchMore()
    HapticManager.notification(type: .success)
  }
  
  private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
    var updatedCoins = filterCoins(text: text, coins: coins)
    
    sortCoins(coins: &updatedCoins, sort: sort)
    return updatedCoins
  }
  
  private func sortCoins(coins: inout [CoinModel], sort: SortOption) {
    switch sort {
    case .price:
      coins.sort { $0.currentPrice > $1.currentPrice }
    case .priceReversed:
      coins.sort { $0.currentPrice < $1.currentPrice }
    case .rank, .holdings:
      coins.sort { $0.rank < $1.rank }
    case .rankReversed, .holdingsReversed:
      coins.sort { $0.rank > $1.rank }
    }
  }
  
  private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
    // only sort by holdings/reversed holdings if needed
    switch sortOption {
    case .holdings:
      return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue}
    case .holdingsReversed:
      return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue}
    default:
      return coins
    }
  }
  
  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else { return coins }
    
    let lowercasedSearchText = text.lowercased()
    return coins.filter {
      $0.name.lowercased().contains(lowercasedSearchText) ||
      $0.symbol.lowercased().contains(lowercasedSearchText) ||
      $0.id.lowercased().contains(lowercasedSearchText)
    }
  }
  
  private func mapAllCoinsToPortfolio(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
    allCoins.compactMap { (coin) -> CoinModel? in
      guard
        let entity = portfolioCoins.first(where: { $0.coinID == coin.id })
      else {
        return nil
      }
      
      return coin.updateHoldings(amount: entity.amount)
    }
  }
  
  private func getPortfolioValue(portfolioCoins: [CoinModel]) -> StatisticModel {
    let currentValue = portfolioCoins
      .map({ $0.currentHoldingsValue })
      .reduce(0, +)
    
    let previousValue = portfolioCoins
      .map { (coin: CoinModel) -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
        let previousValue = currentValue / (1 + percentChange)
        return previousValue
      }
      .reduce(0, +)
    
    let percentChange = ((currentValue - previousValue) / previousValue) * 100
    
    return StatisticModel(
      title: "Portfolio Value",
      value: currentValue.asCurrencyWith2Decimals(),
      percentChange: percentChange.isNaN ? 0 : percentChange
    )
  }
  
  private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    
    guard let data = marketDataModel else { return stats }
    
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "Volume", value: data.volume)
    let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    let portfolioValue = getPortfolioValue(portfolioCoins: portfolioCoins)
    
    stats.append(contentsOf: [
      marketCap,
      volume,
      btcDominance,
      portfolioValue
    ])
    
    return stats
  }
}


