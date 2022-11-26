//
//  NetworkingManager.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 21.11.2022.
//

import Foundation
import SwiftUI
import Combine
import Network

class NetworkManager {
  let monitor = NWPathMonitor()
  let queue = DispatchQueue(label: "NetworkManager")
  @Published var isConected: Bool = true
  
  var connectionDescription: String {
    if isConected {
      return "Conection is good"
    } else {
      return "You're not connected to the internet"
    }
  }
  
  init() {
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.isConected = path.status == .satisfied
      }
    }
    monitor.start(queue: queue)
  }
  
  private func download(url: URL) -> AnyPublisher<Data, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .default ))
      .tryMap { (output) -> Data in
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
              }
        return output.data
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

// MARK: - Movies

protocol MovieAPIProtocol {
  func getMoviews(searchText: String) -> AnyPublisher<[MovieAPIModel], Error>
}

extension NetworkManager: MovieAPIProtocol {
  func getMoviews(searchText: String) -> AnyPublisher<[MovieAPIModel], Error> {
    Just(searchText)
      .tryMap {
        guard let url = URL(string: "https://api.tvmaze.com/search/shows?q=\($0)") else {
          throw URLError(.badURL)
        }
        return url
      }
      .flatMap { [unowned self] in
        self.download(url: $0)
          .decode(type: [MovieAPIModel].self, decoder: JSONDecoder())
      }
      .eraseToAnyPublisher()
  }
}
