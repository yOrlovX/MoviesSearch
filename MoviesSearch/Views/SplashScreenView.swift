//
//  SplashScreenView.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 24.11.2022.
//

import SwiftUI

struct SplashScreenView: View {
  let networkManager: NetworkManager
  let dbManager: CoreDataManager
  let mainViewModel: MainViewModel
  let favouritesViewModel: FavouritesViewModel
  
  init() {
    networkManager = .init()
    dbManager = .init()
    mainViewModel = .init(networkManager: networkManager, dbManager: dbManager)
    favouritesViewModel = .init(dbManager: dbManager)
  }
  
  @State private var isActive = false
  @State private var size = 0.8
  @State private var opacity = 0.5
  @State private var rotationEffect: Double = 0
  private let animation = Animation.easeIn(duration: 1.2)
  
  var body: some View {
    ZStack {
      if networkManager.isConected {
        animationState
      } else {
        VStack {
          Text(networkManager.connectionDescription)
        }
      }
    }
    .environmentObject(mainViewModel)
    .environmentObject(favouritesViewModel)
  }
}

extension SplashScreenView {
  private var animationState: some View {
    ZStack {
      if isActive {
        HomeView()
      } else {
        VStack {
          VStack {
            SwiftUI.Image(systemName: "sparkle.magnifyingglass")
              .font(.system(size: 80))
              .foregroundColor(.green)
              .padding()
              .rotationEffect(Angle(degrees: rotationEffect))
              .onAppear{
                withAnimation(animation) {
                  rotationEffect = 360
                }
              }
            Text("Find your movie")
              .font(.system(size: 26, weight: .bold))
          }
          .scaleEffect(size)
          .opacity(opacity)
          .onAppear {
            withAnimation(animation) {
              self.size = 1
              self.opacity = 1.0
            }
          }
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isActive = true
          }
        }
      }
    }
  }
}

struct SplashScreenView_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreenView()
  }
}
