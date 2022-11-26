//
//  MainViewModel.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 22.11.2022.
//

import Foundation
import Combine

typealias MainViewModelDBManager = MovieDBProtocol & FavoriteMovieDBProtocol

class MainViewModel: ObservableObject {
  @Published var searchQuery = ""
  @Published var allMovies: Movies = []
  
  let networkManager: MovieAPIProtocol
  let dbManager: MainViewModelDBManager
  var cancellables: Set<AnyCancellable> = []
  
  init(networkManager: MovieAPIProtocol,
       dbManager: MainViewModelDBManager) {
    self.networkManager = networkManager
    self.dbManager = dbManager
    $searchQuery
      .removeDuplicates()
      .debounce(for: 1, scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] searchText in
        if searchText != "", searchText.count > 2 {
          self?.getMovies(by: searchText)
        }
      })
      .store(in: &cancellables)
  }
  
  func getMovies(by text: String) {
    networkManager.getMoviews(searchText: text)
      .map { result in result.map { MovieModel(response: $0) }}
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print(error)
        }
      } ,receiveValue: { [weak self] returnedMovies in
        self?.allMovies = returnedMovies
      })
      .store(in: &cancellables)
  }
}
