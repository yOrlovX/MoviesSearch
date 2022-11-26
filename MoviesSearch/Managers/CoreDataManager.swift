//
//  CoreDataManager.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 23.11.2022.
//

import Combine
import CoreData

class CoreDataManager {
  private let container: NSPersistentContainer
  fileprivate var context: NSManagedObjectContext { container.viewContext }
  
  init() {
    container = NSPersistentContainer(name: "DataContainer")
    let description = NSPersistentStoreDescription()
    description.shouldMigrateStoreAutomatically = true
    description.shouldInferMappingModelAutomatically = true
    container.persistentStoreDescriptions.append(description)
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading Core Data \(error)")
      }
    }
  }
}

// MARK: - Movie

protocol MoviesDBProtocol {
  func getSavedMovies() -> AnyPublisher<[MovieModel], Error>
}

protocol MovieDBProtocol {
  func save(movie: MovieModel) -> AnyPublisher<Void, Error>
  func deleteMovie(id: Int) -> AnyPublisher<Void, Error>
}

protocol FavoriteMovieDBProtocol {
  func isFavorite(id: Int) -> AnyPublisher<Bool, Never>
}

extension CoreDataManager: MoviesDBProtocol, FavoriteMovieDBProtocol, MovieDBProtocol {
  func save(movie: MovieModel) -> AnyPublisher<Void, Error> {
    Just(movie.convertToEntity(context: context))
      .tryMap { [unowned self] _ in
        try self.context.save()
        return ()
      }
      .eraseToAnyPublisher()
  }
  
  func getSavedMovies() -> AnyPublisher<[MovieModel], Error> {
    Just(MoviesEntity.fetchRequest())
      .tryMap { [unowned self] in
        let results = try self.context.fetch($0)
        return results.compactMap { $0.convertToUIModel }
      }
      .eraseToAnyPublisher()
  }
  
  func deleteMovie(id: Int) -> AnyPublisher<Void, Error> {
    let fetchRequest = MoviesEntity.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
    return Just(NSBatchDeleteRequest(fetchRequest: fetchRequest))
      .tryMap { [unowned self] in
        try self.context.execute($0)
        try self.context.save()
        return ()
      }
      .eraseToAnyPublisher()
  }
  
  func isFavorite(id: Int) -> AnyPublisher<Bool, Never> {
    let fetchRequest = MoviesEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
    return Just(fetchRequest)
      .tryMap { [unowned self] in
        let result = try self.context.count(for: $0)
        return result > 0
      }
      .replaceError(with: false)
      .eraseToAnyPublisher()
  }
}

private extension MoviesEntity {
  var convertToUIModel: MovieModel? {
    guard let name = name,
          let url = url,
          let image = image else {
            return nil
          }
    return MovieModel(id: Int(id), score: score, url: url, name: name, rating: rating, image: image, summary: summary)
  }
}

private extension MovieModel {
  func convertToEntity(context: NSManagedObjectContext) -> MoviesEntity {
    let entity = MoviesEntity(context: context)
    
    entity.id = Int64(id)
    entity.name = name
    entity.summary = summary
    entity.score = score
    entity.url = url
    entity.image = image
    entity.rating = rating ?? 0
    
    return entity
  }
}
