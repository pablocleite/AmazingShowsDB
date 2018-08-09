//
//  TraktShowDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

final class TraktShowDataManager: BaseDataManager<[Show]> {
    
    static let trendingTracktShowsURL = URL(string: "https://api.trakt.tv/shows/trending")
    
    let apiVersion = "2"
    
    override init() {
        super.init()
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration?.httpAdditionalHeaders = [
            "Content-type" : "application/json",
            "trakt-api-key" : apiKeyFor(service: .trakt),
            "trakt-api-version" : apiVersion
        ]
    }
    
    override func performFetch(result: @escaping (Result<[Show]>) -> Void) {
        guard let url = TraktShowDataManager.trendingTracktShowsURL else {
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
