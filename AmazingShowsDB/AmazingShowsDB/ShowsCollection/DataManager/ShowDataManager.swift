//
//  ShowDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

struct ShowDataManager {
    
    //TODO: Move this to a abstract class?
    enum Result<T> {
        case success(T)
        case error(Error)
    }
    
    let trendingTracktShowsURL = URL(string: "https://api.trakt.tv/shows/trending")
    
    
    //APP Client ID
    let tracktAPIKey = "c3334a9c126666d7139b1e264c5aabfb58dd31a381569d4fd865d11810a165f6"
    let apiVersion = "2"
    
    func fetchShows(result: @escaping (Result<[Show]>) -> Void) {
        guard let url = trendingTracktShowsURL else {
            print("serviceURL cannot be nil!")
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Content-type" : "application/json",
            "trakt-api-key" : tracktAPIKey,
            "trakt-api-version" : apiVersion
        ]
        
        URLSession(configuration: sessionConfig).dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                //TODO: get error and call a completion handler!
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let shows = try decoder.decode([Show].self, from: data)
                result(.success(shows))
            } catch {
                result(.error(error))
            }
        }.resume()
    }
    
}
