//
//  Models.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 21.11.2022.
//

import Foundation

// MARK: - Movie

// Api
struct MovieAPIModel: Codable {
  struct Show: Codable {
    struct Image: Codable {
      let medium, original: String
    }
    
    struct Rating: Codable {
      let average: Double?
    }
    
    let id: Int
    let url: String
    let name: String
    let rating: Rating
    let image: Image
    let summary: String?
  }
  
  let score: Double
  let show: Show
}

// UI

struct MovieModel: Hashable {
  let id: Int
  let score: Double
  let url: String
  let name: String
  let rating: Double?
  let image: String
  let summary: String?
  
  init(id: Int, score: Double, url: String, name: String, rating: Double?, image: String, summary: String?) {
    self.id = id
    self.score = score
    self.url = url
    self.name = name
    self.rating = rating
    self.image = image
    self.summary = summary
  }
  
  init(response: MovieAPIModel) {
    id = response.show.id
    score = response.score
    url = response.show.url
    name = response.show.name
    rating = response.show.rating.average
    image = response.show.image.medium
    summary = response.show.summary
  }
}

typealias Movies = [MovieModel]
