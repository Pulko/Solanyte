//
//  PortfolioDataService.swift
//  CryptoTrackerTutorial
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
    self.getWallet()
  }
  
  // MARK: Public  
  func updatePortfolio(coins: [CoinModel]) {
    coins.forEach { coin in
      let amount = coin.currentHoldings ?? 0.0

      if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
        if amount > 0 {
          update(entity: entity, amount: amount)
        } else {
          delete(entity: entity)
        }
      } else {
        add(coin: coin, amount: amount)
      }
    }
    
    applyChanges()
  }
  
  func updateWallet(key: String, balance: Double = 0) {
    if let entity = savedWallet {
      updateWalletEntity(entity: entity, balance: balance, key: key)
    } else {
      addWalletEntity(balance: balance, key: key)
    }
  }
  
  func deleteAll() -> Void {
    savedEntities.forEach { container.viewContext.delete($0) }
    if let walletEntity = savedWallet {
      walletContainer.viewContext.delete(walletEntity)
    }
    fromWallet = false
    savedEntities.removeAll()
    savedCoins.removeAll()
    self.save(container: container)
  }
  
  func reload() -> Void {
    self.getPortfolio()
    self.getWallet()
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
  
  private func getWallet() -> Void {
    let walletRequest = NSFetchRequest<WalletEntity>(entityName: walletEntityName)
    
    do {
      savedWallet = try walletContainer.viewContext.fetch(walletRequest).first
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
    entity.balance = balance
    entity.key = key

    save(container: walletContainer)
    getWallet()
  }
  
  private func addWalletEntity(balance: Double, key: String) {
    let entity = WalletEntity(context: walletContainer.viewContext)
    entity.balance = balance
    entity.key = key
    
    save(container: walletContainer)
    getWallet()
  }
  
  // Portfolio
  
  private func add(coin: CoinModel, amount: Double) -> Void {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    
    save(container: container)
  }
  
  private func update(entity: PortfolioEntity, amount: Double) {
    entity.amount = amount

    save(container: container)
  }
  
  private func applyChanges() {
    save(container: container)
    getPortfolio()
  }
  
  private func delete(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    
    save(container: container)
  }
  
  // MARK: fetch data
  
  private func handleSavedEntities() -> Void {
    let ids = self.savedEntities.compactMap { $0.coinID }.uniqued().filter { $0 != "" }
    fromWallet = !ids.isEmpty
    let tryMap = { (models: [CoinModel]) -> [CoinModel] in
      models.map { (model: CoinModel) in
        let amount = self.savedEntities.first(where: { $0.coinID == model.id })?.amount ?? 0
        
        return model.updateHoldings(amount: amount)
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
