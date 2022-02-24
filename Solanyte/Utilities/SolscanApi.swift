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
  }
  
  static var url = SolscanUrl()
  
  static func fetchTokenDataByMint(
    mint: PublicKey,
    amount: TokenAmount?,
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
