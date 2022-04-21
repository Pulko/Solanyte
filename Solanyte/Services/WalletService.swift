//
//  WalletService.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 29.01.22.
//

import Foundation
import Combine
import Solana

class WalletService {
  private var cancellables = Set<AnyCancellable>()
  
  private let solanaApiService = SolanaApiService()
  private var solanaBalance: Double = 0
  private var walletsCount: Int = 0
  
  @Published var tokens: Array<TokenData> = []
  @Published var coins: Array<CoinModel> = []
  
  func fetch(pubkey: String) {
    self.clear()
    self.getWallets(walletPublicKey: pubkey)
    self.getBalance(walletPublicKey: pubkey)
  }
  
  private func clear() -> Void {
    self.tokens.removeAll()
    self.coins.removeAll()
    self.solanaBalance = 0
  }
  
  private func getWallets(walletPublicKey: String) -> Void {
    solanaApiService.actions.getTokenWallets(account: walletPublicKey) { (result: Result<[Wallet], Error>) in
      SolanaApiService.handleResult(result, errorText: "Unable to get wallets from Solana API") { (wallets: [Wallet]) -> Void in
        self.walletsCount = wallets.count
        self.getTokens(wallets: wallets)
      }
    }
  }
  
  private func getBalance(walletPublicKey: String) -> Void {
    solanaApiService.api.getBalance(account: walletPublicKey, commitment: nil) { (result: Result<UInt64, Error>) in
      SolanaApiService.handleResult(result, errorText: "Unable to get balance from Solana API") { (balance: UInt64) -> Void in
        self.solanaBalance = Double(balance) * SolanaApiService.lamport
      }
    }
  }
  
  func getTokens(wallets: Array<Wallet> = []) -> Void {
    if wallets.count > 0 {
      wallets.forEach { (wallet: Wallet) in
        if let address = wallet.token?.address,
           let mint = PublicKey(string: address) {
          
          SolscanApiService.fetchTokenDataByMint(
            mint: mint,
            receiveValue: { [weak self] tokenData in
              self?.tokens.append(tokenData.assignAmount(amount: wallet.ammount))
            })
            .store(in: &self.cancellables)
        }
      }
    }
  }
  
  func getCoins(tokens: Array<TokenData> = []) -> Void {
    if (tokens.count == self.walletsCount) {
      var ids = tokens.uniqued().compactMap { $0.coingeckoID }.filter { $0 != "" }
      ids.append(CoingeckoApiService.solanaId)
      
      let tryMap = { (models: [CoinModel]) -> [CoinModel] in
        models.map { (model: CoinModel) in
          let found = tokens.first(where: { $0.coingeckoID == model.id })
          var amount: Double = 0.0
          
          if (model.id == CoingeckoApiService.solanaId) {
            amount = self.solanaBalance
          } else {
            amount = Double(found?.amount?.uiAmountString ?? "0") ?? 0.0
          }
          
          return model.updateHoldings(amount: amount)
        }
      }
      
      CoingeckoApiService.fetchCoinModelsByIds(
        ids: ids,
        tryMap: tryMap,
        receiveValue: { [weak self] coinModels in
          self?.coins.append(contentsOf: coinModels)
        })
        .store(in: &self.cancellables)
    }
  }
}
