//
//  TokenData.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 25.01.22.
//

import Foundation
import Solana

struct TokenData: Codable, Hashable {
  let symbol, name: String?
  let icon: String?
  let website, twitter: String?
  let decimals: Int?
  let coingeckoID: String?
  let holder: Int?
  var amount: TokenAmount?
  var mintAddress: String?
  
  enum CodingKeys: String, CodingKey {
    case symbol, name, icon, website, twitter, decimals
    case coingeckoID = "coingeckoId"
    case holder
  }
  
  init(
    symbol: String?,
    name: String?,
    icon: String?,
    website: String?,
    twitter: String?,
    decimals: Int?,
    coingeckoID: String?,
    holder: Int?,
    amount: TokenAmount?,
    mintAddress: String? = ""
  ) {
    self.symbol = symbol
    self.name = name
    self.icon = icon
    self.website = website
    self.twitter = twitter
    self.decimals = decimals
    self.holder = holder
    self.coingeckoID = coingeckoID
    self.amount = amount
    self.mintAddress = mintAddress
  }
  
  func assignAmountAndMintAddress(amount: TokenAmount?, mintAddress: String) -> TokenData {
    return TokenData(symbol: symbol, name: name, icon: icon, website: website, twitter: twitter, decimals: decimals, coingeckoID: coingeckoID, holder: holder, amount: amount, mintAddress: mintAddress)
  }
}
