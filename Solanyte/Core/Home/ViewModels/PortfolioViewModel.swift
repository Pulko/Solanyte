//
//  PortfolioViewModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 24.01.22.
//

import Foundation

class PortfolioViewModel: ObservableObject {
  @Published var walletAddress: String
  @Published var isError: Bool = false
  @Published var isLoading: Bool = false
  
  init() {
    self.walletAddress = ""
  }
  
  func detchWalletByAddress(address: String) -> Void {
    let isValidated: Bool = validateWalletAddress(address)
    
    if isValidated {
      self.isLoading = true
    } else {
      self.isError = true
    }
  }
  
  private func validateWalletAddress(_ address: String) -> Bool {
//    let isLengthPassed = address.count >= 32 && address.count <= 44
    let isLengthPassed = true
    
    return isLengthPassed
  }
}
