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
    
    private var tmdbIdShowDict:[Int:Show] {
        var tmdbIdShowDict = [Int:Show]()
        if let shows = shows {
            shows.forEach { (show) in
                if let tmdbId = show.serviceIds?.tmdb {
                    tmdbIdShowDict[tmdbId] = show
                }
            }
        }
        return tmdbIdShowDict
    }
    
    func loadShows() {
        let showsDataManager = TraktShowDataManager()
        showsDataManager.performFetch() { [weak self] (result) in
            switch (result) {
            case .success(let shows):
                self?.shows = shows
                let viewModels = shows.map({ ShowViewModel(show: $0) })
                //Notify delegate rightaway while we load the posters!
                self?.delegate?.didFinishLoadingShows(shows: viewModels)
            case .error(let error):
                self?.delegate?.loadingShowsFailed(error)
            }
        }
    }
    
    private func loadPosters() {
        guard let shows = shows, !shows.isEmpty else {
            //Nothing to load
            return
        }
        
        let posterDataManager = TMDBPosterDataManager(showIds: Set(tmdbIdShowDict.keys))
        posterDataManager.performFetch { [weak self] (result) in
            switch result {
            case .success(let postersDict):
                var viewModels = [ShowViewModel]()
                for (tmdbId, poster) in postersDict {
                    if let show = self?.tmdbIdShowDict[tmdbId] {
                        viewModels.append(ShowViewModel(show: show, withPosterUrl: poster.posterUrl))
                    }
                }
                self?.delegate?.didFinishLoadingShows(shows: viewModels)
            case .error(let error):
                self?.delegate?.loadingShowsFailed(error)
            }
        }
    }
    
}
