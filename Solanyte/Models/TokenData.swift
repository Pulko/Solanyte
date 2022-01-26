//
//  TokenData.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 25.01.22.
//

import Foundation

struct TokenData: Codable, Hashable {
  let symbol, name: String
  let icon: String
  let website, twitter: String
  let decimals: Int
  let coingeckoID: String
  let holder: Int
  
  enum CodingKeys: String, CodingKey {
    case symbol, name, icon, website, twitter, decimals
    case coingeckoID = "coingeckoId"
    case holder
  }
}
