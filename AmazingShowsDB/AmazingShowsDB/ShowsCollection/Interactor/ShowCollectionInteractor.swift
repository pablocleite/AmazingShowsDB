//
//  ShowCollectionInteractor.swift
//  AmazingShowsDB
//
//  Created by Pablo Cobucci Leite on 08/08/18.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

protocol ShowCollectionInteractorProtocol: AnyObject {
  var delegate: ShowCollectionInteractorDelegate? {get set}
  
  func loadShows()
}

protocol ShowCollectionInteractorDelegate: AnyObject {
  func didFinishLoadingShows(shows: [ShowViewModel])
  func loadingShowsFailed(_ error: Error)
}

class ShowCollectionInteractor: ShowCollectionInteractorProtocol {
  
  weak var delegate: ShowCollectionInteractorDelegate?
  
  private var shows:[Show]? {
    didSet {
      loadPosters()
    }
  }
  
  private(set) var showViewModels = [ShowViewModel]()
  
  func loadShows() {
    let showsDataManager = ShowDataManager()
    showsDataManager.performFetch() { [weak self] (result) in
      switch (result) {
      case .success(let shows):
        self?.shows = shows
      case .error(let error):
        self?.delegate?.loadingShowsFailed(error)
      }
    }
  }
  
  private func loadPosters() {
    guard let shows = shows else {
      //Nothing to load
      return
    }
    
    shows.forEach { (show) in
      if let tmdbId = show.serviceIds?.tmdb {
        let posterDataManager = TMDBPosterDataManager(showId: tmdbId)
        //TODO: Improve this instead of calling the delegate for each downloaded object...
        posterDataManager.performFetch { [weak self] (result) in
          switch result {
          case .success(let poster):
            self?.showViewModels.append(ShowViewModel(show: show, withPosterUrl: poster.posterUrl))
            if let viewModels = self?.showViewModels {
              self?.delegate?.didFinishLoadingShows(shows: viewModels)
            }
          case .error(let error):
            print(error)
            //TODO: Call delegate!?
          }
        }
      }
    }
  }
  
}
