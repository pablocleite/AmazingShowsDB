//
//  TMDBPosterEntity.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

struct TMDBPosterEntity: Decodable {
  static let tmdbImagesEndPoint = URL(string: "https://image.tmdb.org/t/p/w342")
  
  let filePath: String
  
  var posterUrl: URL? {
    return TMDBPosterEntity.tmdbImagesEndPoint?.appendingPathComponent(filePath)
  }
}
