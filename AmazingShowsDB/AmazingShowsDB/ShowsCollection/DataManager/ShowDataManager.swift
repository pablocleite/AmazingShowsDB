//
//  ShowDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

final class ShowDataManager: BaseDataManager<[Show]> {
    
    let trendingTracktShowsURL = URL(string: "https://api.trakt.tv/shows/trending")
    
    
    //APP Client ID
    let tracktAPIKey = "c3334a9c126666d7139b1e264c5aabfb58dd31a381569d4fd865d11810a165f6"
    let apiVersion = "2"
  
  override init() {
    super.init()
    sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration?.httpAdditionalHeaders = [
      "Content-type" : "application/json",
      "trakt-api-key" : tracktAPIKey,
      "trakt-api-version" : apiVersion
    ]
  }
  
  override func performFetch(result: @escaping (Result<[Show]>) -> Void) {
    guard let url = trendingTracktShowsURL else {
      print("serviceURL cannot be nil!")
      return
    }
    
    fetchDataFromUrl(url) { (dataResult) in
      switch dataResult {
      case .success(let data):
        let decoder = JSONDecoder()
        do {
          let shows = try decoder.decode([Show].self, from: data)
          result(.success(shows))
        } catch {
          result(.error(error))
        }
      case .error(let error):
        result(.error(error))
      }
    }
  }
}
