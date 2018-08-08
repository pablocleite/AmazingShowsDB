//
//  TMDBPosterDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation


final class TMDBPosterDataManager: BaseDataManager<TMDBPosterEntity> {
  private struct TMDBImagesEntity: Decodable {
    let posters: [TMDBPosterEntity]
  }
    static let tmdbApiKey = "c637fc098e8e7406ab5721e72585640e"
    static let tmdbBaseUrl = URL(string: "https://api.themoviedb.org/3/")

    
    var apiKeyParam: String {
        return "?api_key=\(TMDBPosterDataManager.tmdbApiKey)"
    }
  
  private let showId: Int
  
  init(showId: Int) {
    self.showId = showId
  }

    
    func buildImageUrl() -> URL? {
        let endpoint = "tv" + "/\(showId)" + "/images" + apiKeyParam
        return TMDBPosterDataManager.tmdbBaseUrl?.appendingPathComponent(endpoint)
    }
  
  override func performFetch(result: @escaping (Result<TMDBPosterEntity>) -> Void) {
    guard let url = buildImageUrl() else {
        //TODO: Add error handling!
        return
    }

    fetchDataFromUrl(url) { (dataResult) in
      switch dataResult {
      case .success(let data):
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
          let images = try decoder.decode(TMDBImagesEntity.self, from: data)
          if let poster = images.posters.first {
            result(.success(poster))
          } else {
            //TODO: Call completion block with nil?
          }
        } catch {
          result(.error(error))
        }
      case .error(let error):
        result(.error(error))
      }
    }
  }
  
}
