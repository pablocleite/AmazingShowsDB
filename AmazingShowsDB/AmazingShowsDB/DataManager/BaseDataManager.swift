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

class BaseDataManager<T> {
  
  var sessionConfiguration: URLSessionConfiguration?
  
  func performFetch(result: @escaping (Result<T>) -> Void) {
    //Default implementation does nothing. This method is meant to be overriden by subclasses
  }
  
  func fetchDataFromUrl(_ url: URL, withResult result: @escaping (Result<Data>) -> Void) {
    
    let urlSession: URLSession
    if let sessionConfiguration = sessionConfiguration {
      urlSession = URLSession(configuration: sessionConfiguration)
    } else {
      urlSession = URLSession.shared
    }
    
    urlSession.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        if let error = error {
          result(.error(error))
        } else {
          result(.error(RequestError.unspecified))
        }
        return
      }
      
      result(.success(data))
      
      }.resume()
  }
  
}
