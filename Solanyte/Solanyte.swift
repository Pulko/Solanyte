//
//  SolanyteApp.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

@main
struct Solanyte: App {
  @StateObject private var vm = HomeViewModel()
  
  @State private var showLaunchView: Bool = true
  
  private let homeTabKey = 1
  private let walletTabKey = 2
  private let settingsTabKey = 3
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UITableView.appearance().backgroundColor = UIColor.clear
    UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    UITextView.appearance().backgroundColor = UIColor.clear
    UITextField.appearance().backgroundColor = UIColor(Color.theme.background)
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        TabView(selection: $vm.tabView) {
          
          NavigationView {
            HomeView()
              .navigationBarHidden(true)
          }
          .tabItem {
            Image(systemName: "house")
            Text("Home".uppercased())
          }
          .tag(homeTabKey)

          NavigationView {
            WalletView()
              .navigationBarHidden(true)
          }
          .tabItem {
            Image(systemName: "server.rack")
            Text("Wallet".uppercased())
          }
          .tag(walletTabKey)

          NavigationView {
            SettingsView()
              .navigationBarHidden(true)
          }
          .tabItem {
            Image(systemName: "slider.horizontal.3")
            Text("Settings".uppercased())
          }
          .tag(settingsTabKey)
          
        }
        .environmentObject(vm)
        .navigationViewStyle(StackNavigationViewStyle())
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
