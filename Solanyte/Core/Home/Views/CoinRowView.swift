//
//  CoinRowView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 14.11.21.
//

import SwiftUI

struct CoinRowView: View {
  let coin: CoinModel
  let showHoldings: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      leftColumn
      Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
      if showHoldings {
        centralColumn
      }
      rightColumn
    }
    .font(.subheadline)
  }
}

struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CoinRowView(coin: dev.coin, showHoldings: true)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
      CoinRowView(coin: dev.coin, showHoldings: true)
        .previewLayout(.sizeThatFits)
    }
    
  }
}

extension CoinRowView {
  private var coinImage: some View {
    CoinImageView(coin: coin)
      .frame(width: 40, height: 40)
  }
  
  private var leftColumn: some View {
    HStack(spacing: 0) {
      coinImage
      VStack(alignment: .leading) {
        Text(coin.symbol.uppercased())
          .lineLimit(1)
          .font(.headline)
          .padding(.leading, 6)
          .foregroundColor(.theme.accent)
        Text("\(coin.rank)")
          .font(.caption)
          .foregroundColor(.theme.secondaryText)
          .padding(.leading, 8)
      }
      
    }
  }
  
  private var rightColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice?.asCurrencyWith6Decimals() ?? "0.0")
        .bold()
        .foregroundColor(.theme.accent)
      Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
        .foregroundColor(
          (coin.priceChangePercentage24H ?? 0) >= 0
          ? .theme.green
          : .theme.red
        )
        .font(.caption2)
    }
    .lastColumnStyled()
  }
  
  private var centralColumn: some View {
    VStack(alignment: .trailing) {
      if coin.currentHoldingsValue > 0 {
        Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
          .bold()
          .foregroundColor(.theme.accent)
        Text(Double(coin.currentHoldings ?? 0).asFloatWith4Decimals())
          .foregroundColor(.theme.secondaryText)
          .font(.caption2)
          .bold()
      }
    }
  }
}
