//
//  CoinDetailDataService.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation
import Combine
import Solana

class CoinDetailDataService {
  @Published var coinDetails: CoinDetailModel? = nil
  @Published var tokenHolders: [HolderData]? = []
  var coinDetailsSubscription: AnyCancellable?
  private var cancellables = Set<AnyCancellable>()
  
  let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
    getCoinDetails(coinId: coin.id)
    
    if let mintAddress = coin.mintAddress {
      getTokenHolders(mintAddress: mintAddress)
    }
  }
  
  func reload() -> Void {
    getCoinDetails(coinId: coin.id)
    
    if let mintAddress = coin.mintAddress {
      getTokenHolders(mintAddress: mintAddress)
    }
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
  
  private func getTokenHolders(mintAddress: String) {
    let pubKey = PublicKey(string: mintAddress)!
    
    SolscanApiService.fetchTokenHoldersByMint(mint: pubKey) {
      [weak self] returnedData in
      self?.tokenHolders = returnedData.data
    }
    .store(in: &self.cancellables)
  }
}
