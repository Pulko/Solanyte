//
//  SolscanApi.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 22.02.22.
//

import Foundation
import Solana
import Combine

struct SolscanApiService {
  struct SolscanUrl {
    func tokenDataByMint(_ mint: String) -> URL {
      URL(string: "https://public-api.solscan.io/token/meta?tokenAddress=\(mint)")!
    }
    
    func tokenHoldersByMint(_ mint: String) -> URL {
      URL(string: "https://public-api.solscan.io/token/holders?tokenAddress=\(mint)&offset=0&limit=10")!
    }
  }
  

  
  static var url = SolscanUrl()
  
  static func fetchTokenHoldersByMint(
    mint: PublicKey,
    receiveValue: @escaping (GlobalHolderData) -> Void
  ) -> AnyCancellable {
    NetworkingManager.download(url: url.tokenHoldersByMint(mint.base58EncodedString))
      .decode(type: GlobalHolderData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: receiveValue
      )
  }
  
  static func fetchTokenDataByMint(
    mint: PublicKey,
    receiveValue: @escaping (TokenData) -> Void
  ) -> AnyCancellable {
    NetworkingManager.download(url: url.tokenDataByMint(mint.base58EncodedString))
      .decode(type: TokenData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: receiveValue
      )
  }
}
