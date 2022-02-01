//
//  PortfolioViewModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 24.01.22.
//

import Foundation
import Combine
import Solana

class PortfolioViewModel: ObservableObject {
  @Published var isError: Bool = false
  @Published var isLoading: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  private var walletService: WalletService? = nil
  
  func fetchWalletByAddress() -> Void {
    let isValidated: Bool = validateWalletAddress(self.walletAddress)
    
    if isValidated {
      self.isLoading = true
      
      walletService = WalletService(pubkey: self.walletAddress)
      addSubscribers()
    } else {
      self.isError = true
    }
  }
  
  private func validateWalletAddress(_ address: String) -> Bool {
    let isLengthPassed = address.count >= 32 && address.count <= 44
    
    return isLengthPassed
  }
  
  @Published var walletAddress: String = ""
  @Published var wallets: Array<Wallet> = []
  @Published var coins: Array<CoinModel> = []
  
  
  private func addSubscribers() {
    if let walletService = walletService {
      walletService.$wallets
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (returnedWallets: Array<Wallet>) in
          self?.wallets = returnedWallets
          self?.isError = false
        }
        .store(in: &cancellables)
      
      walletService.$coins
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (returnedCoins: Array<CoinModel>) in
          self?.coins = returnedCoins.uniqued()
          self?.isLoading = false
          self?.isError = false
        }
        .store(in: &cancellables)
    }
  }
}
