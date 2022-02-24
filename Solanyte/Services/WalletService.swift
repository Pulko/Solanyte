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
  
  @Published var wallets: Array<Wallet> = []
  @Published var tokens: Array<TokenData> = []
  @Published var coins: Array<CoinModel> = []

  @Published var walletValue: Double = 0
  
  init(pubkey: String) {
    self.getWallets(walletPublicKey: pubkey)
    self.getBalance(walletPublicKey: pubkey)
  }
  
  private func getWallets(walletPublicKey: String) -> Void {
    solanaApiService.actions.getTokenWallets(account: walletPublicKey) { (result: Result<[Wallet], Error>) in
      SolanaApiService.handleResult(result, errorText: "Unable to get wallets from Solana API") { (wallets: [Wallet]) -> Void in
        self.wallets = wallets
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
            amount: wallet.ammount,
            receiveValue: { [weak self] tokenData in
              self?.tokens.append(tokenData.assignAmount(amount: wallet.ammount))
            })
            .store(in: &self.cancellables)
        }
      }
    }
  }
  
  func getCoins(tokens: Array<TokenData> = []) -> Void {
    if tokens.count > 0 {
      var ids = tokens.uniqued().compactMap { $0.coingeckoID }
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
          
          self.walletValue += amount

          return model.updateHoldings(amount: amount)
        }
      }
      
      CoingeckoApiService.fetchCoinModelsByIds(
        ids: ids,
        tryMap: tryMap,
        receiveValue: { [weak self] coinModels in
          self?.coins = coinModels
        })
        .store(in: &self.cancellables)
    }
  }
}
