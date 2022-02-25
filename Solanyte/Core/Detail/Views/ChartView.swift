//
//  ChartView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import SwiftUI

struct ChartView: View {
  @State private var animationPercentage: CGFloat = 0
  
  private let data: [Double]
  private let minY: Double
  private let maxY: Double
  private let lineColor: Color
  
  private let startingDate: Date
  private let endingDate: Date
  
  init(sparkline: SparklineIn7D?, lastUpdated: String?) {
    data = sparkline?.price ?? []
    minY = data.min() ?? 0
    maxY = data.max() ?? 0
    
    let priceChange = ((data.last ?? 0) - (data.first ?? 0))
    lineColor = priceChange > 0 ? .green : .red
    
    startingDate = Date(coinGeckoString: lastUpdated ?? "")
    endingDate = startingDate.addingTimeInterval(7*24*60*60)
  }
  
  var body: some View {
    VStack {
      chartView
        .frame(height: 200)
        .background(chartBackground)
        .overlay(chartYAxisCoords.padding(), alignment: .leading)
      chartXAxisCoords.padding()
    }
    .font(.caption)
    .foregroundColor(.theme.secondaryText)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        withAnimation(.linear(duration: 1.0)) {
          animationPercentage = 1.0
        }
      }
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(sparkline: dev.coin.sparklineIn7D, lastUpdated: dev.coin.lastUpdated)
  }
}

extension ChartView {
  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let xPosition = geometry.size.width / CGFloat(data.count)*(CGFloat(index + 1))
          let yPosition = CGFloat(1 - (data[index] - minY) / (maxY - minY)) * geometry.size.height
          
          if index == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }
          
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0.0, to: animationPercentage)
      .stroke(lineColor.opacity(Double(animationPercentage)), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 10, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.5), radius: 5, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.2), radius: 5, x: 0, y: 15)
      .shadow(color: lineColor.opacity(0.1), radius: 5, x: 0, y: 20)
    }
  }
  
  private var chartYAxisCoords: some View {
    VStack(alignment: .leading) {
      Text(maxY.asCurrencyWith6Decimals())
      Spacer()
      Text((minY + ((maxY - minY) / 2)).asCurrencyWith6Decimals())
      Spacer()
      Text(minY.asCurrencyWith6Decimals())
    }
  }
  
  private var chartXAxisCoords: some View {
    HStack {
      Text(startingDate.asShortDateString())
      Spacer()
      Text(endingDate.asShortDateString())
    }
  }
  
  private var chartBackground: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
}
