//
//  ShowCollectionInteractorTest.swift
//  AmazingShowsDBTests
//
//  Created by Pablo Leite on 08/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import XCTest
@testable import AmazingShowsDB

class ShowCollectionInteractorTest: XCTestCase {
    
    class MockShowCollectionPresenter: ShowCollectionPresenterProtocol, ShowCollectionInteractorDelegate {
        
        var shows: [ShowViewModel]?
        var didCallFinishLoading = false
        var didLoadFail = false
        
        var finishLoadingExpectation: XCTestExpectation!
        
        func didFinishLoadingShows(shows: [ShowViewModel]) {
            self.shows = shows
            finishLoadingExpectation.fulfill()
        }
        
        func loadingShowsFailed(_ error: Error) {
            didLoadFail = true
        }
        
        var view: ShowCollectionViewProtocol!
        
        var interactor: ShowCollectionInteractorProtocol!
        
        func updateView() {
            
        }
        
    }

    var presenter: MockShowCollectionPresenter!
    var interactor: ShowCollectionInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = ShowCollectionInteractor()
        presenter = MockShowCollectionPresenter()
        presenter.interactor = interactor
        interactor.delegate = presenter
    }
    
    func testInit() {
        XCTAssert(interactor != nil)
    }
    
    func testInterator() {
        presenter.finishLoadingExpectation = expectation(description: "Loaded shows.")
        interactor.loadShows()
        waitForExpectations(timeout: 2.0, handler: nil)
        if let shows = presenter.shows {
            XCTAssert(!shows.isEmpty)
        } else {
            XCTFail("Interactor set no object as shows arrays on the presenter")
        }
        
    }
    
}