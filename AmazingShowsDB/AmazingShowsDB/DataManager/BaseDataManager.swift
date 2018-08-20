//
//  BaseDataManager.swift
//  AmazingShowsDB
//
//  Created by Pablo Cobucci Leite on 08/08/18.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

enum RequestError: Error {
    case unspecified
}

enum Service: String {
    case trakt = "trakt"
    case tmdb = "tmdb"
}

class BaseDataManager<T> {
    
    var sessionConfiguration: URLSessionConfiguration = {
        var sessionConfiguration = URLSessionConfiguration.default
        //Url will be displayed as a memory leak on the instruments, let's disable it for now.
        sessionConfiguration.urlCache = nil;
        sessionConfiguration.timeoutIntervalForRequest = 20.0;
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData;
        return sessionConfiguration
    }()
    
    func performFetch(result: ((Result<T>) -> Void)?) {
        //Default implementation does nothing. This method is meant to be overriden by subclasses
    }
    
    func fetchDataFromUrl(_ url: URL, withResult result: ((Result<Data>) -> Void)?) {
        
        let urlSession = URLSession(configuration: sessionConfiguration)

        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    result?(.error(error))
                } else {
                    result?(.error(RequestError.unspecified))
                }
                return
            }
            
            result?(.success(data))
            
            }.resume()
    }
}

extension BaseDataManager {
    func apiKeyFor(service: Service) -> String {
        if let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath) as? [String : AnyObject] {
            return plist[service.rawValue] as! String
        } else {
            return ""
        }
    }
}
