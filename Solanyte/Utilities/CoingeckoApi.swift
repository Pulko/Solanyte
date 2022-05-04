//
//  CoingeckoApi.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 01.02.22.
//

import Foundation
import Solana
import Combine


class CoingeckoApiService {
  struct CoingeckoUrl {
    func marketData(ofSolana: Bool = false, perPage: Int = 100, currentPage: Int = 1) -> URL {
      URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&\(ofSolana ? "category=solana-ecosystem&" : "")order=market_cap_desc&per_page=\(perPage)&page=\(currentPage)&sparkline=true&price_change_percentage=24h")!
    }
    
    func globalData() -> URL {
      URL(string: "https://api.coingecko.com/api/v3/global")!
    }
    
    func coinDetailById(_ id: String) -> URL {
      URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true")!
    }
    
    func coinModelsByIds(_ ids: Array<String>) -> URL {
      URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(ids.joined(separator: ","))&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=7d")!
    }
  }
  
  static var url = CoingeckoUrl()
  static var solanaId = "solana"
  static var solanaMintAddress = "So11111111111111111111111111111111111111112"
  
  static func fetchCoinDetailById(
    id: String,
    amount: Double,
    tryMap: @escaping (CoinDetailModel) -> CoinModel,
    receiveValue: @escaping (CoinModel) -> Void
  ) -> AnyCancellable {
    return NetworkingManager.download(url: url.coinDetailById(id))
      .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
      .tryMap(tryMap)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: self.receive,
        receiveValue: receiveValue
      )
  }
  
  static func fetchCoinModelsByIds(
    ids: Array<String>,
    tryMap: @escaping ([CoinModel]) -> [CoinModel] = { $0 },
    receiveValue: @escaping ([CoinModel]) -> Void
  ) -> AnyCancellable {
    return NetworkingManager.download(url: url.coinModelsByIds(ids))
      .decode(type: Array<CoinModel>.self, decoder: JSONDecoder())
      .tryMap(tryMap)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: self.receive,
        receiveValue: receiveValue
      )
  }
  
  static fileprivate var receive = { (completion: (Subscribers.Completion<Error>)) in
    switch completion {
    case .failure(let error):
      print(NetworkingManager.NetworkingError.badResponse(error: error))
      
    case .finished:
      break
    }
    
  }
}


