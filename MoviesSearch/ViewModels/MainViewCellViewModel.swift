//
//  MainViewCellViewModel.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 22.11.2022.
//

import SwiftUI
import Combine
import CoreData

class MainViewCellViewModel: ObservableObject {
  @Published var isFavorite = false
  
  let dbManager: MainViewModelDBManager
  var cancellables: Set<AnyCancellable> = []
  
  init(dbManager: MainViewModelDBManager) {
    self.dbManager = dbManager
  }
  
  func checkIsFavorite(id: Int) {
    dbManager.isFavorite(id: id)
      .sink { [weak self] in
        self?.isFavorite = $0
      }
      .store(in: &cancellables)
  }
  
  func save(rowData: MovieModel) {
    dbManager.save(movie: rowData)
      .sink(receiveCompletion: { [weak self] in
        guard case .finished = $0 else {
          return
        }
        self?.isFavorite = true
      }, receiveValue: {})
      .store(in: &cancellables)
  }
  
  func deleteRowData(id: Int) {
    dbManager.deleteMovie(id: id)
      .sink(receiveCompletion: { [weak self] in
        guard case .finished = $0 else {
          return
        }
        self?.isFavorite = false
      }, receiveValue: {})
      .store(in: &cancellables)
  }
}
