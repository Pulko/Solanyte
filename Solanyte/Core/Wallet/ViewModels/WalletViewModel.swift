//
//  WalletViewModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 24.01.22.
//

import Foundation
import Combine
import Solana

class WalletViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var isError: Bool = false
  @Published var isReady: Bool = false
  
  @Published var walletAddress: String = ""
  @Published var coins: Array<CoinModel> = []
  @Published var walletValue: Double = 0
  
  private var cancellables = Set<AnyCancellable>()
  
  private var walletService: WalletService? = nil
  
  func fetchWalletByAddress() -> Void {
    let isValidated: Bool = validateWalletAddress(self.walletAddress)
    
    if isValidated {
      self.isLoading = true
      
      walletService = WalletService(pubkey: self.walletAddress)
      HapticManager.notification(type: .success)
      addSubscribers()
    } else {
      self.isLoading = false
      self.isError = true
    }
  }
  
  func deleteAll() -> Void {
    self.walletAddress = ""
    self.coins.removeAll()
    self.walletValue = 0
    self.isLoading = false
    self.isError = false
    self.isReady = false
  }
  
  private func validateWalletAddress(_ address: String) -> Bool {
    let isLengthPassed = address.count >= 32 && address.count <= 44
    
    return isLengthPassed
  }
  
  private func addSubscribers() {
    if let walletService = walletService {
      walletService.$tokens
        .receive(on: DispatchQueue.main)
        .sink { walletService.getCoins(tokens: $0) }
        .store(in: &cancellables)
      
      walletService.$coins
        .receive(on: DispatchQueue.main)
        .map(sortCoins)
        .sink { [weak self] (returnedCoins: Array<CoinModel>) in
          self?.coins = returnedCoins.uniqued()
          
          if ((self?.coins.count ?? 0) > 0) {
            self?.isLoading = false
            self?.isReady = true
          } else {
            self?.isLoading = true
          }
        }
        .store(in: &cancellables)
      
      walletService.$walletValue
        .receive(on: DispatchQueue.main)
        .sink { [weak self] returnedWalletValue in
          self?.walletValue = returnedWalletValue
        }
        .store(in: &cancellables)
    }
  }
  
  private func sortCoins(coins: [CoinModel]) -> [CoinModel] {
    var cloneCoins = coins
    
    SortManager.sortCoins(coins: &cloneCoins)
    return cloneCoins
  }
}
