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
  private var coinSubscription: AnyCancellable?
  private var currentPage: Int = 1
  var perPage: Int = 100
  
  init() {
    getCoins(coinDataUrl: coinDataUrl)
  }
  
  private func getCoinDataUrl() -> String {
    "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(perPage)&page=\(self.currentPage)&sparkline=true&price_change_percentage=24h"
  }
  
  func reload() {
    getCoins(coinDataUrl: coinDataUrl)
  }
  
  func fetchMore() {
    if allCoins.count == perPage * currentPage {
      currentPage += 1
    }
    self.getCoins(coinDataUrl: getCoinDataUrl(), appending: true)
  }
  
  private func getCoins(coinDataUrl: String, appending: Bool = false) {
    guard let url = URL(string: coinDataUrl) else { return }
    
    coinSubscription = NetworkingManager.download(url: url, onError: { self.currentPage -= 1 })
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] returnedCoins in
          if appending {
            self?.allCoins.append(contentsOf: returnedCoins)
          } else {
            self?.allCoins = returnedCoins
          }
          self?.coinSubscription?.cancel()
        })
  }
}
