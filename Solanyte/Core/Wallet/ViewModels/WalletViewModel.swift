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
  
  private var cancellables = Set<AnyCancellable>()
  
  private var walletService = WalletService()
  
  func fetchWalletByAddress() -> Void {
    let isValidated: Bool = validateWalletAddress(self.walletAddress)
    
    if isValidated {
      self.coins.removeAll()
      self.isLoading = true
      self.isError = false
      
      walletService.fetch(pubkey: self.walletAddress)
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
    self.isLoading = false
    self.isError = false
    self.isReady = false
  }
  
  private func validateWalletAddress(_ address: String) -> Bool {
    let isLengthPassed = address.count >= 32 && address.count <= 44
    
    return isLengthPassed
  }
  
  private func addSubscribers() {
    walletService.$tokens
      .receive(on: DispatchQueue.main)
      .sink { self.walletService.getCoins(tokens: $0) }
      .store(in: &cancellables)
    
    walletService.$coins
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (returnedCoins: Array<CoinModel>) in
        self?.coins = returnedCoins.uniqued()
        
        self?.isLoading = false
        self?.isReady = true
      }
      .store(in: &cancellables)
  }
}
