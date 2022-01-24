//
//  SolanaApi.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 25.01.22.
//

import Foundation
import Solana

class SolanaApiService {
  let api: Api
  let actions: Action
  
  init() {
    let network = NetworkingRouter(endpoint: .mainnetBetaSolana)
    let solana = Solana(router: network, accountStorage: KeychainAccountStorageModule())
    self.api = solana.api
    self.actions = solana.action
  }
  
  enum SolanaApiError: LocalizedError {
    case solanaApiResponse(error: Error, errorText: String)
    
    var errorDescription: String? {
      switch self {
      case .solanaApiResponse(error: let error, errorText: let errorText):
        return "[🚨] \(errorText): \(error)"
      }
    }
  }
  
  static func handleResult<T>(_ result: Result<T, Error>, errorText: String, onSuccess: @escaping (T) -> Void) -> Void {
    switch result {
    case .success(let success):
      onSuccess(success)
    case .failure(let error):
      print(SolanaApiError.solanaApiResponse(error: error, errorText: errorText))
    }
  }
}
