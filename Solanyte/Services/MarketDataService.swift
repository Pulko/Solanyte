//
//  MarketDataService.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

import Foundation
import Combine

let marketsDataUrl = "https://api.coingecko.com/api/v3/global"

class MarketDataService {
  @Published var marketData: MarketDataModel? = nil
  var marketDataSubscription: AnyCancellable?
  
  init() {
    getData()
  }
  
  func reload() {
    getData()
  }
  
  private func getData() {
    guard let url = URL(string: marketsDataUrl) else { return }
    
    marketDataSubscription = NetworkingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] returnedGlobalData in
          self?.marketData = returnedGlobalData.data
          self?.marketDataSubscription?.cancel()
        })
  }
}

