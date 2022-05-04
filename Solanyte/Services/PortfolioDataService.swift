//
//  PortfolioDataService.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 20.12.21.
//

import Foundation
import CoreData
import Solana
import Combine

class PortfolioDataService {
  private let container: NSPersistentContainer
  private let walletContainer: NSPersistentContainer
  
  private let portfolioContainerName: String = "PortfolioContainer"
  private let portfolioEntityName: String = "PortfolioEntity"
  private let walletEntityName: String = "WalletEntity"
  private let walletContainerName: String = "WalletModel"
  
  @Published var savedEntities: [PortfolioEntity] = []
  @Published var savedWallet: WalletEntity? = nil
  @Published var savedWallets: [WalletEntity] = []
  @Published var savedCoins: [CoinModel] = []
  @Published var fromWallet: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    container = NSPersistentContainer(name: portfolioContainerName)
    walletContainer = NSPersistentContainer(name: walletContainerName)
    
    walletContainer.loadPersistentStores { _, error in
      if let error = error {
        print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
      }
    }
    container.loadPersistentStores { _, error in
      if let error = error {
        print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
      }
    }
    
    self.getPortfolio()
    self.getWallets()
  }
  
  // MARK: Public
  func updatePortfolio(coins: [CoinModel]) {
    deleteSavedEntities()
    
    coins.forEach { addPortfolioEntity(coin: $0, amount: $0.currentHoldings ?? 0.0) }
    
    save(container: container)
    getPortfolio()
  }
  
  func updateWallet(key: String, balance: Double = 0, current: Bool = true) {
    let existingEntity = savedWallets.first { $0.key == key }
    
    if let entity = existingEntity {
      updateWalletEntity(entity: entity, balance: balance, key: key)
    } else {
      if savedWallets.count < ConstantManager.MAX_AMOUNT_STORED_WALLETS {
        addWalletEntity(balance: balance, key: key, current: current)
      } else {
        return
      }
    }
    
    save(container: walletContainer)
    getWallets()
  }
  
  func removeWallet(key: String) -> Void {
    if let entity = savedWallets.first(where: { $0.key == key }) {
      walletContainer.viewContext.delete(entity)
      
      if entity.current {
        self.savedCoins.removeAll()
        self.fromWallet = false
        deleteSavedEntities()
      }
    }
    
    self.save(container: walletContainer)
    getWallets()
  }
  
  func reload() -> Void {
    self.getPortfolio()
    self.getWallets()
  }
  
  // MARK: Private
  
  private func getPortfolio() -> Void {
    let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntityName)
    
    do {
      savedEntities = try container.viewContext.fetch(request)
      
      self.handleSavedEntities()
    } catch let error {
      print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
    }
  }
  
  private func getWallets() -> Void {
    let walletRequest = NSFetchRequest<WalletEntity>(entityName: walletEntityName)
    
    do {
      savedWallets = try walletContainer.viewContext.fetch(walletRequest)
      savedWallet = savedWallets.first(where: { $0.current })
    } catch let error {
      print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
    }
  }
  
  private func save(container: NSPersistentContainer) {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving to core data: \(error)")
    }
  }
  
  // Wallet
  
  private func updateWalletEntity(entity: WalletEntity, balance: Double, key: String) {
    savedWallets.forEach { entity in
      entity.current = false
    }
    
    entity.balance = balance
    entity.key = key
    entity.current = true
  }
  
  private func addWalletEntity(balance: Double, key: String, current: Bool = true) {
    if current {
      savedWallets.forEach { entity in
        entity.current = false
      }
    }
    
    let entity = WalletEntity(context: walletContainer.viewContext)
    entity.balance = balance
    entity.key = key
    
    if current {
      entity.current = true
    }
  }
  
  // Portfolio
  
  private func addPortfolioEntity(coin: CoinModel, amount: Double) -> Void {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    entity.mint = coin.mintAddress
    
    save(container: container)
  }
  
  private func deleteSavedEntities() -> Void {
    savedEntities.forEach { container.viewContext.delete($0) }
    savedEntities.removeAll()
    
    save(container: container)
  }
  
  // MARK: fetch data
  
  private func handleSavedEntities() -> Void {
    let ids = self.savedEntities.compactMap { $0.coinID }.uniqued().filter { $0 != "" }
    
    if (!ids.isEmpty) {
      fromWallet = !ids.isEmpty
      
      let tryMap = { (models: [CoinModel]) -> [CoinModel] in
        models.map { (model: CoinModel) in
          let amount = self.savedEntities.first(where: { $0.coinID == model.id })?.amount ?? 0
          let mint = self.savedEntities.first(where: { $0.coinID == model.id })?.mint ?? ""
          
          return model.updateHoldingsAndMintAddress(currentHoldings: amount, mintAddress: mint)
        }
      }
      
      CoingeckoApiService.fetchCoinModelsByIds(
        ids: ids,
        tryMap: tryMap,
        receiveValue: { [weak self] coinModels in
          self?.savedCoins = coinModels
        })
        .store(in: &self.cancellables)
    }
  }
}
