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
  
  @Published var wallets: Array<Wallet> = [] {
    didSet {
      self.getTokens()
    }
  }
  @Published var tokens: Array<TokenData> = [] {
    didSet {
      if oldValue.count == self.wallets.count - 1 {
        self.getCoins()
      }
    }
  }
  
  @Published var coins: Array<CoinModel> = []
  @Published var walletValue: Double = 0
  
  init(pubkey: String) {
    self.getTokenWallets(walletPublicKey: pubkey)
  }
  
  func getTokenWallets(walletPublicKey: String) -> Void {
    solanaApiService.actions.getTokenWallets(account: walletPublicKey) { (result: Result<[Wallet], Error>) in
      SolanaApiService.handleResult(result, errorText: "Unable to perform an action") { (wallets: [Wallet]) -> Void in
        self.wallets = wallets
      }
    }
  }
  
  func getTokens() -> Void {
    if self.wallets.count > 0 {
      self.wallets.forEach { (wallet: Wallet) in
        if let address = wallet.token?.address,
           let mint = PublicKey(string: address) {
          self.fetchTokenDataByMint(mint: mint, amount: wallet.ammount)
        }
      }
    }
  }
  
  private func fetchTokenDataByMint(mint: PublicKey, amount: TokenAmount?) -> Void {
    NetworkingManager.download(url: CoingeckoApiService.url.tokenDataByMint(mint.base58EncodedString))
      .decode(type: TokenData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] tokenData in
          self?.tokens.append(tokenData.assignAmount(amount: amount))
        })
      .store(in: &self.cancellables)
  }
  
  func getCoins() -> Void {
    if self.tokens.count > 0 {
      self.tokens
        .compactMap { $0 }
        .forEach { (token: TokenData) in
          if let coingeckoID = token.coingeckoID {
            self.fetchCoinDataByCoingeckoId(id: coingeckoID, amount: token.amount)
          } else {
            self.appendCustomCoinData(token: token)
          }
        }
    }
  }
  
  private func appendCustomCoinData(token: TokenData) -> Void {
    if let symbol = token.symbol {
      self.coins.append(
        CoinModelFactory.custom(
          id: symbol,
          symbol: symbol,
          name: token.name ?? "n/a",
          currentHoldings: Double(token.amount?.uiAmountString ?? "0") ?? 0.0,
          image: token.icon ?? ""
        )
      )
    }
  }
  
  private func fetchCoinDataByCoingeckoId(id: String, amount: TokenAmount?) -> Void {
    CoingeckoApiService.fetchCoinDetailById(
      id: id,
      amount: Double(amount?.uiAmountString ?? "0") ?? 0.0,
      tryMap: { CoinModel(coinDetailModel: $0) },
      receiveValue: { [weak self] coinModel in
        if let uiAmount = amount?.uiAmountString {
          self?.coins.append(coinModel.updateHoldings(amount: Double(uiAmount)!))
          self?.walletValue += Double(uiAmount) ?? 0
        } else {
          self?.coins.append(coinModel)
        }
      })
      .store(in: &self.cancellables)
  }
}
