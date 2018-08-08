//
//  ShowsCollectionRouter.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 08/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import UIKit

protocol ShowsCollectionRouterProtocol {
    //Empty as there's no navigation in this app yet
}

class ShowsCollectionRouter: ShowsCollectionRouterProtocol {
    
    var navigationViewController: UINavigationController?
    
    static func presentShowsCollection() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: ShowsCollectionViewController.identifier)
        var showCollectionViewController = mainViewController as! ShowCollectionViewProtocol
        let presenter = ShowCollectionPresenter()
        let interactor = ShowCollectionInteractor()
        presenter.interactor = interactor
        showCollectionViewController.presenter = presenter
        
        return UINavigationController(rootViewController: mainViewController)
    }
}
