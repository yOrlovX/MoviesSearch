//
//  ContentView.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 23.11.2022.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  
  var body: some View {
    NavigationView {
      List(mainViewModel.allMovies, id: \.id) { data in
        MainViewCell(mainViewCellViewModel: .init(dbManager: mainViewModel.dbManager), rowData: data)
          .buttonStyle(PlainButtonStyle())
      }
      .navigationTitle("Main")
      .searchable(text: $mainViewModel.searchQuery)
      .onChange(of: mainViewModel.searchQuery) { newValue in
        if !newValue.isEmpty {
          mainViewModel.getMovies(by: newValue)
        }
      }
      .onAppear {
        if mainViewModel.searchQuery.isEmpty {
          mainViewModel.getMovies(by: "top")
        }
      }
      .overlay {
        emptySearchOverlay
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  private var emptySearchOverlay: some View {
    VStack {
      if mainViewModel.allMovies.isEmpty && !mainViewModel.searchQuery.isEmpty{
        EmptyView(text: $mainViewModel.searchQuery)
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
