//
//  TMDBPosterDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation


final class TMDBPosterDataManager: BaseDataManager<[Int:TMDBPosterEntity]> {
    private struct TMDBImagesEntity: Decodable {
        let posters: [TMDBPosterEntity]
    }
    static let tmdbApiKey = "c637fc098e8e7406ab5721e72585640e"
    static let tmdbBaseUrl = URL(string: "https://api.themoviedb.org/3/")
    
    
    var apiKeyParam: String {
        return "?api_key=\(TMDBPosterDataManager.tmdbApiKey)"
    }
    
    private let showIds: Set<Int>
    
    private var errors: [Error] = []
    private var postersDict: [Int:TMDBPosterEntity] = [:]
    
    init(showIds: Set<Int>) {
        self.showIds = showIds
    }
    
    
    func buildImageUrl(showId: Int) -> URL? {
        let endpoint = "tv" + "/\(showId)" + "/images" + apiKeyParam
        return URL(string: endpoint, relativeTo: TMDBPosterDataManager.tmdbBaseUrl)
    }
    
    override func performFetch(result: @escaping (Result<[Int:TMDBPosterEntity]>) -> Void) {
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "thread-safe-array-access", attributes: .concurrent)
        
        for showId in showIds {
            guard let url = buildImageUrl(showId: showId) else {
                break
            }
            
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                defer { group.leave() }
                
                guard let data = data else {
                    self.errors.append(RequestError.unspecified)
                    return
                }
                if let error = error {
                    self.errors.append(error)
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let images = try decoder.decode(TMDBImagesEntity.self, from: data)
                    if let poster = images.posters.first {
                        queue.async(flags: .barrier) {
                            self.postersDict[showId] = poster
                        }
                    }
                } catch {
                    self.errors.append(error)
                }
                
            }
            
            group.enter()
            
            task.resume()
        }
        
        group.notify(queue: .main) {
            guard !self.postersDict.isEmpty && self.errors.isEmpty else {
                result(.error(RequestError.unspecified))
                return
            }
            
            queue.sync {
                result(.success(self.postersDict))
            }
        }
    }
}
