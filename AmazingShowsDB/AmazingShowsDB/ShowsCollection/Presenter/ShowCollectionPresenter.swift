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
  
  //TODO: Add dependecy injection here!
  var interactor: ShowCollectionInteractorProtocol! = ShowCollectionInteractor() {
    didSet {
      interactor.delegate = self
    }
  }
  
  //TODO: Remove this init!
  init() {
    interactor.delegate = self
  }
  
  func updateView() {
      interactor.loadShows()
  }
  
  func didFinishLoadingShows(shows: [ShowViewModel]) {
    //TODO: Presenter shoud receive entity and convert into the view model ?
    view?.shows = shows
  }

  func loadingShowsFailed(_ error: Error) {
    //TODO: Display some kind of error
  }

}
