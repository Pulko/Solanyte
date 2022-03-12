//
//  LaunchView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 09.01.22.
//

import SwiftUI

struct LaunchView: View {
  @State private var loadingText: [String] = "solanyte".uppercased().map { String($0) }
  @State private var showLoadingText: Bool = false
  @State private var counter: Int = 0
  @State private var loops: Int = 0

  @Binding var showLaunchView: Bool
  
  private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.theme.background.ignoresSafeArea()
      Image("solanyte-transparent")
        .resizable()
        .frame(width: 100, height: 100)
      ZStack {
        if showLoadingText {
          HStack(spacing: 0) {
            ForEach(loadingText.indices) { index in
              Text(loadingText[index])
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .offset(x: counter == index ? -1 : 0)
            }
          }
          .transition(AnyTransition.scale.animation(.easeIn))
        }
      }
      .offset(y: 70)
      .onAppear {
        showLoadingText.toggle()
      }
      .onReceive(timer, perform: { _ in
        let lastIndex = loadingText.count - 1
        
        if (counter == lastIndex) {
          counter = 0
          loops += 1

          if (loops >= 2) {
            showLaunchView = false
          }
        } else {
          counter += 1
        }
      })
    }
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView(showLaunchView: .constant(true))
      .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
