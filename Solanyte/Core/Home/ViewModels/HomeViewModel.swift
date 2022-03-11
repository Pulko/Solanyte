//
//  HomeViewModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 15.11.21.
//

import Foundation
import SwiftUI
import Combine

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
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  func updatePortfolio(coins: [CoinModel]) {
    portfolioDataService.updatePortfolio(coins: coins)
  }
  
  func updateWallet(key: String, balance: Double) {
    portfolioDataService.updateWallet(key: key, balance: balance)
  }
  
  func resetWalletValue() {
    if let key = self.walletEntity?.key {
      portfolioDataService.updateWallet(key: key, balance: self.portfolioValue)
    }
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
    
    self.reloadData()
  }
  
  private func filterAndSortCoins(coins: [CoinModel], sort: SortOption, filter: Bool) -> [CoinModel] {
    var cloneCoins = coins
    
    SortManager.filterCoins(coins: &cloneCoins, filter: filter)
    SortManager.sortCoins(coins: &cloneCoins, sort: sort)
    return cloneCoins
  }
}


