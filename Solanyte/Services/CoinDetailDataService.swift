//
//  CoinDetailDataService.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation
import Combine

class CoinDetailDataService {
  @Published var coinDetails: CoinDetailModel? = nil
  var coinDetailsSubscription: AnyCancellable?
  
  let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
    getCoinDetails(coinId: coin.id)
  }
  
  func reload() -> Void {
    getCoinDetails(coinId: coin.id)
  }
  
  private func coinUrlById(_ coinId: String) -> String {
    "https://api.coingecko.com/api/v3/coins/\(coinId)?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true"
  }
  
  private func getCoinDetails(coinId: String) {
    guard let url = URL(string: coinUrlById(coinId)) else { return }
    
    coinDetailsSubscription = NetworkingManager.download(url: url)
      .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] returnedCoinDetails in
          self?.coinDetails = returnedCoinDetails
          self?.coinDetailsSubscription?.cancel()
        })
  }
}
