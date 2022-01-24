//
//  KeychainAccountStorage.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 25.01.22.
//

import Foundation
import Solana

enum SolanaAccountStorageError: Error {
  case unauthorized
}
struct KeychainAccountStorageModule: SolanaAccountStorage {
  private let tokenKey = "keychain_solana_storage"
  private let keychain = KeychainSwift()
  
  func save(_ account: Account) -> Result<Void, Error> {
    do {
      let data = try JSONEncoder().encode(account)
      keychain.set(data, forKey: tokenKey)
      return .success(())
    } catch {
      return .failure(error)
    }
  }
  
  var account: Result<Account, Error> {
    // Read from the keychain
    guard let data = keychain.getData(tokenKey) else { return .failure(SolanaAccountStorageError.unauthorized)  }
    if let account = try? JSONDecoder().decode(Account.self, from: data) {
      return .success(account)
    }
    return .failure(SolanaAccountStorageError.unauthorized)
  }

  func clear() -> Result<Void, Error> {
    keychain.clear()
    return .success(())
  }
}
