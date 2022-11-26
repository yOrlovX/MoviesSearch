//
//  FavouritesViewModel.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 22.11.2022.
//

import SwiftUI
import Combine
import CoreData

typealias FavouritesViewModelDBManager = MovieDBProtocol & MoviesDBProtocol

class FavouritesViewModel: ObservableObject {
  @Published var favouritesMovies: Movies = []
  @Published var searchResults: Movies = []
  @Published var searchQuery = ""
  
  let dbManager: FavouritesViewModelDBManager
  var cancellables: Set<AnyCancellable> = []
  
  init(dbManager: FavouritesViewModelDBManager) {
    self.dbManager = dbManager
  }
  
  func getMovies() {
    dbManager.getSavedMovies()
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] in
        self?.favouritesMovies = $0
      })
      .store(in: &cancellables)
  }
  
  func save(movie: MovieModel) {
    dbManager.save(movie: movie)
      .sink(receiveCompletion: { _ in }, receiveValue: {})
      .store(in: &cancellables)
  }
  
  func deleteMovie(id: Int) {
    dbManager.deleteMovie(id: id)
      .sink(receiveCompletion: { _ in }, receiveValue: {})
      .store(in: &cancellables)
  }
}
