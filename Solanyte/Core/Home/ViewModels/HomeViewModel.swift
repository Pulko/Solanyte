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
  @Published var isLoading: Bool = false
  @Published var isError: Bool = false
  
  @Published var portfolioCoins: [CoinModel] = []
  @Published var portfolioValue: Double = 0
  @Published var sortOption: SortOption = .rank
  
  private let portfolioDataService = PortfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  var isListFull: Bool = false
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    // update portfolio coins
    portfolioDataService.$savedCoins
      .combineLatest($sortOption)
      .map(filterAndSortCoins)
      .sink { [weak self] (returnedCoins: [CoinModel]) in
        
        self?.portfolioCoins = returnedCoins.uniqued()
      }
      .store(in: &cancellables)
    
    
    $portfolioCoins
      .sink { [weak self] (coins: [CoinModel]) in
        self?.portfolioValue = coins.reduce(0) { $0 + $1.currentHoldingsValue }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
          self?.isLoading = false
        }
      }
      .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    portfolioDataService.reload()
    HapticManager.notification(type: .success)
  }
  
  func removeData() {
    isLoading = true
    portfolioDataService.deleteAll()
    HapticManager.notification(type: .success)
  }
  
  private func filterAndSortCoins(coins: [CoinModel], sort: SortOption) -> [CoinModel] {
    var cloneCoins = coins
    
    sortCoins(coins: &cloneCoins, sort: sort)
    return cloneCoins
  }
  
  private func sortCoins(coins: inout [CoinModel], sort: SortOption) {
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


