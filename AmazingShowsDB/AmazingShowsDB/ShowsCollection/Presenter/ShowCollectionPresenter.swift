//
//  ShowCollectionPresenterProtocol.swift
//  AmazingShowsDB
//
//  Created by Pablo Cobucci Leite on 08/08/18.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

protocol ShowCollectionPresenterProtocol: AnyObject {
    var view: ShowCollectionViewProtocol! { get set }
    var interactor: ShowCollectionInteractorProtocol! { get set }
    func updateView()
}

class ShowCollectionPresenter: ShowCollectionPresenterProtocol, ShowCollectionInteractorDelegate {
    
    var view: ShowCollectionViewProtocol!
    
    var interactor: ShowCollectionInteractorProtocol! {
        didSet {
            interactor.delegate = self
        }
    }
    
    func updateView() {
        if view.shows == nil {
            //Only display loading if view is empty.
            view?.displayLoadingShows()
        }
        interactor.loadShows()
    }
    
    func didFinishLoadingShows(shows: [ShowViewModel]) {
        view?.shows = shows
    }
    
    func loadingShowsFailed(_ error: Error) {
        view?.displayError()
    }
    
}
