//
//  TMDBPosterDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

struct TMDBPosterDataManager {
    let tmdbApiKey = "c637fc098e8e7406ab5721e72585640e"
    let tmdbBaseUrl = URL(string: "https://api.themoviedb.org/3/")
    
    //TODO: Put this on an UIImage extension and do it!
    let tmdbImagesEndPoint = "https://image.tmdb.org/t/p/w342"
    
    let configurationEndPoint = "configuration"
    
    var apiKeyParam: String {
        return "?api_key=\(tmdbApiKey)"
    }

    
    func buildImageUrl(showId: Int) -> URL? {
        let endpoint = "tv" + "/\(showId)" + "/images" + apiKeyParam
        return URL(string: endpoint, relativeTo: tmdbBaseUrl)
    }
    
    private func fetchApiConfiguration() {
        guard let configurationUrl = URL(string: configurationEndPoint + apiKeyParam, relativeTo: tmdbBaseUrl) else {
            //TODO: Add some error handling here!
            return
        }
        
        URLSession.shared.dataTask(with: configurationUrl) { (data, response, error) in
            //TODO: retrieve the configuration here and cache it somewhere.
        }
    }
    
    func fetchPosterUrl(tmdbId: Int) {
        
        guard let showImagesUrl = buildImageUrl(showId: tmdbId),
            tmdbId != -1 else {
                //TODO: Add error handling!
                return
        }
        
        URLSession.shared.dataTask(with: showImagesUrl) { (data, response, error) in
            guard let data = data else {
                //TODO: get error and call a completion handler!
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let images = try decoder.decode(TMDBImagesEntity.self, from: data)
                //TODO Call the completionBlock!
                let poster = images.posters.first
            } catch {
                //TODO: Call the completion block here!
                print(error)
            }
        }.resume()
    }
    
    
}
