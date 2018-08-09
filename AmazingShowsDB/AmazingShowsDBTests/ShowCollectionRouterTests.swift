//
//  AmazingShowsDBTests.swift
//  AmazingShowsDBTests
//
//  Created by Pablo Leite on 08/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import XCTest
@testable import AmazingShowsDB

class ShowCollectionRouterTests: XCTestCase {
    
    func testPresentShowCollectionViewController() {
        let vc = ShowsCollectionRouter.presentShowsCollection()
        XCTAssert(vc is UINavigationController)
        let navigationVc = vc as! UINavigationController
        XCTAssert(!navigationVc.viewControllers.isEmpty)
        let rootVc = navigationVc.viewControllers.first
        XCTAssert(rootVc is ShowsCollectionViewController)
        
    }
}
