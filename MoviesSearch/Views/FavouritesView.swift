//
//  FavouritesView.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 23.11.2022.
//

import SwiftUI

struct FavouritesView: View {
  @EnvironmentObject var favouritesViewModel: FavouritesViewModel
  var listData: Movies {
    if favouritesViewModel.searchQuery.isEmpty {
      return favouritesViewModel.favouritesMovies
    } else {
      return favouritesViewModel.searchResults
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        if favouritesViewModel.favouritesMovies.isEmpty {
          Text("You dont have favorites yet")
            .font(.headline)
        } else {
          List(listData, id: \.self) { data in
            FavouritesCell(rowData: data)
              .buttonStyle(PlainButtonStyle())
          }
          .navigationBarTitle("Favourites")
          .searchable(text: $favouritesViewModel.searchQuery, placement:.navigationBarDrawer(displayMode: .always))
          .onChange(of: favouritesViewModel.searchQuery) { _ in
            favouritesViewModel.searchResults = favouritesViewModel.favouritesMovies.filter({ result in
              result.name.contains(favouritesViewModel.searchQuery) && favouritesViewModel.searchQuery.count > 1
            })
          }
          .overlay {
            emptySearchOverlay
          }
        }
      }
      .onAppear {
        favouritesViewModel.getMovies()
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  private var emptySearchOverlay: some View {
    VStack {
      if favouritesViewModel.searchResults.isEmpty && !favouritesViewModel.searchQuery.isEmpty {
        EmptyView(text: $favouritesViewModel.searchQuery)
      }
    }
  }
}

struct FavouritesView_Previews: PreviewProvider {
  static var previews: some View {
    FavouritesView()
  }
}
