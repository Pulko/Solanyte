//
//  CryptoTrackerTutorialApp.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

@main
struct Solanyte: App {
  @StateObject private var vm = HomeViewModel()
  @StateObject private var portfolioVm = PortfolioViewModel()
  
  @State private var showLaunchView: Bool = true
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UITableView.appearance().backgroundColor = UIColor.clear
    UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        NavigationView {
          HomeView()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(vm)
        .environmentObject(portfolioVm)
        .opacity(showLaunchView ? 0.0 : 1.0)
        
        ZStack {
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .bottom))
          }
        }
        .zIndex(10.0)
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          withAnimation(.linear) {
            showLaunchView = false
          }
        }
      }
    }
  }
}
