//
//  ShowCollectionPresenterTests.swift
//  AmazingShowsDBTests
//
//  Created by Pablo Leite on 08/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import XCTest
@testable import AmazingShowsDB

class ShowCollectionPresenterTests: XCTestCase {
    
    class MockShowCollectionView: ShowCollectionViewProtocol {
        var didSetShows = false
        var presenter: ShowCollectionPresenterProtocol!
        var shows: [ShowViewModel]? {
            didSet {
                didSetShows = true
            }
        }
    }
    
    class MockShowCollectionInteractor: ShowCollectionInteractorProtocol {
        var delegate: ShowCollectionInteractorDelegate?
        
        var didCallLoadShows = false
        func loadShows() {
            didCallLoadShows = true
            delegate?.didFinishLoadingShows(shows: [])
        }
    }
    
    
    var view: MockShowCollectionView!
    var presenter: ShowCollectionPresenter!
    var interactor: MockShowCollectionInteractor!
    
    override func setUp() {
        super.setUp()
        presenter = ShowCollectionPresenter()
        interactor = MockShowCollectionInteractor()
        presenter.interactor = interactor
        view = MockShowCollectionView()
        presenter.view = view
    }
    
    func testInit() {
        XCTAssert(presenter != nil)
    }
    
    func testView() {
        let presenter = self.presenter!
        presenter.updateView()
        
        XCTAssert(interactor.didCallLoadShows)
        XCTAssert(view.didSetShows)
    }

}
