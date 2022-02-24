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
  @Published var fromWallet: Bool = false
  
  @Published var portfolioCoins: [CoinModel] = []
  @Published var walletEntity: WalletEntity? = nil
  @Published var portfolioValue: Double = 0
  
  @Published var isAboveZero: Bool = false
  @Published var sortOption: SortOption = .holdings
  
  private let portfolioDataService = PortfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    // update portfolio coins
    portfolioDataService.$savedCoins
      .combineLatest($sortOption, $isAboveZero)
      .map(filterAndSortCoins)
      .sink { [weak self] (returnedCoins: [CoinModel]) in
        self?.portfolioCoins = returnedCoins.uniqued()
      }
      .store(in: &cancellables)
    
    portfolioDataService.$savedWallet
      .sink { [weak self] (returnedWallet: WalletEntity?) in
        if let returnedWallet = returnedWallet {
          self?.walletEntity = returnedWallet
        }
      }
      .store(in: &cancellables)
    
    portfolioDataService.$fromWallet
      .sink { [weak self] (fromWallet: Bool) in
        self?.fromWallet = fromWallet
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
  
  func updateWallet(key: String) {
    portfolioDataService.updateWallet(key: key, balance: 0)
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
  
  private func filterAndSortCoins(coins: [CoinModel], sort: SortOption, filter: Bool) -> [CoinModel] {
    var cloneCoins = coins
    
    filterCoins(coins: &cloneCoins, filter: filter)
    sortCoins(coins: &cloneCoins, sort: sort)
    return cloneCoins
  }
  
  private func filterCoins(coins: inout [CoinModel], filter: Bool) {
    if (filter) {
      coins = coins.filter { $0.currentHoldingsValue > 0 }
    }
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


