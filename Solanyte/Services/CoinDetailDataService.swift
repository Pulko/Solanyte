//
//  CoinDetailDataService.swift
//  Solanyte
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
  
  private func getCoinDetails(coinId: String) {
    let url = CoingeckoApiService.url.coinDetailById(coinId)
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
