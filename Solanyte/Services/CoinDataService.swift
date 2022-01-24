//
//  CoinDataService.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 17.11.21.
//

import Foundation
import Combine

let coinDataUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"

let solanaCoinDataUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&category=solana-ecosystem&order=market_cap_desc&per_page=100&page=1&sparkline=true"

class CoinDataService {
  @Published var allCoins: [CoinModel] = []
  var coinSubscription: AnyCancellable?
  
  init() {
    getCoins()
  }
  
  func reload() {
    getCoins()
  }
  
  private func getCoins() {
    guard let url = URL(string: solanaCoinDataUrl) else { return }
    
    coinSubscription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] returnedCoins in
          self?.allCoins = returnedCoins
          self?.coinSubscription?.cancel()
        })
  }
}
