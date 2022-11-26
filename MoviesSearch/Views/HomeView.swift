//
//  MainView.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 21.11.2022.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    TabView {
      MainView()
        .tabItem {
          Label("Main", systemImage: "list.bullet")
        }
      FavouritesView()
        .tabItem {
          Label("Favourites", systemImage: "heart.fill")
        }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
