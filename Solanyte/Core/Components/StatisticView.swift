//
//  StatisticView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

import SwiftUI

struct StatisticView: View {
  let stat: StatisticModel
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(stat.title)
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
      Text(stat.value)
        .font(.headline)
        .foregroundColor(.theme.accent)
      percentChangeView
        .opacity(stat.percentChange != nil ? 1 : 0)
    }
  }
}

extension StatisticView {
  var percentChangeView: some View {
    let percentChangeCoalesed = (stat.percentChange ?? 0)
    
    return (
      HStack {
        Image(systemName: "triangle.fill")
          .font(.caption2)
          .rotationEffect(Angle.init(degrees: percentChangeCoalesed >= 0 ? 0 : 180))
        Text(percentChangeCoalesed.asPercentString())
          .font(.caption)
          .bold()
      }
      .foregroundColor(percentChangeCoalesed >= 0 ? Color.theme.green : Color.theme.red)
    )
  }
}

struct StatisticView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatisticView(stat: dev.stat1)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
      StatisticView(stat: dev.stat2)
      StatisticView(stat: dev.stat3)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)


    }
    .previewLayout(.sizeThatFits)
  }
}
