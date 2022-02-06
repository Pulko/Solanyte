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
  private let containerName: String = "PortfolioContainer"
  private let entityName: String = "PortfolioEntity"
  
  @Published var savedEntities: [PortfolioEntity] = []
  @Published var savedCoins: [CoinModel] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
      }
    }
    self.getPortfolio()
  }
  
  // MARK: Public
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
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
  
  func deleteAll() -> Void {
    savedEntities.forEach { container.viewContext.delete($0) }
    savedEntities.removeAll()
    savedCoins.removeAll()
    self.save()
  }
  
  func reload() -> Void {
    self.getPortfolio()
  }
  
  // MARK: Private
  private func getPortfolio() -> Void {
    let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
    
    do {
      savedEntities = try container.viewContext.fetch(request)
      
      self.handleSavedEntities()
    } catch let error {
      print(NetworkingManager.NetworkingError.badCoreDataResponse(error: error))
    }
  }
  
  private func add(coin: CoinModel, amount: Double) -> Void {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    
    applyChanges()
  }
  
  private func update(entity: PortfolioEntity, amount: Double) {
    entity.amount = amount
    applyChanges()
  }
  
  private func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving to core data: \(error)")
    }
  }
  
  private func applyChanges() {
    save()
    getPortfolio()
  }
  
  private func delete(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }
  
  // MARK: fetch data
  
  private func handleSavedEntities() -> Void {
    self.savedEntities
      .uniqued()
      .forEach { (entity: PortfolioEntity) in
        if let id = entity.coinID {
          self.fetchCoinDataByCoingeckoId(id: id, amount: entity.amount)
        }
      }
  }
  
  private func fetchCoinDataByCoingeckoId(id: String, amount: Double?) -> Void {
    CoingeckoApiService.fetchCoinDetailById(
      id: id,
      amount: amount ?? 0.0,
      tryMap: { CoinModel(coinDetailModel: $0, currentHoldings: amount) },
      receiveValue: { [weak self] coinModel in
        self?.savedCoins.append(coinModel)
      })
      .store(in: &self.cancellables)
  }
}
