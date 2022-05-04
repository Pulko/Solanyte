//
//  HolderData.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 01.05.22.
//

import Foundation

struct GlobalHolderData: Decodable {
  var data: Array<HolderData>? = []
  
  init(data: Array<HolderData>) {
    self.data = data
  }
}

struct HolderData: Hashable, Decodable {
  var address: String
  var owner: String
  var decimals: Int?
  var rank: Int?
  
  enum CodingKeys: String, CodingKey {
    case address, amount, owner, rank, decimals
  }
  
  init(from decoder:Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    address = try values.decode(String.self, forKey: .address)
    owner = try values.decode(String.self, forKey: .owner)
    decimals = try values.decode(Int.self, forKey: .decimals)
    rank = try values.decode(Int.self, forKey: .rank)
  }
  
  init(
    address: String,
    owner: String,
    decimals: Int?,
    rank: Int?
  ) {
    self.address = address
    self.owner = owner
    self.decimals = decimals
    self.rank = rank
  }
}
