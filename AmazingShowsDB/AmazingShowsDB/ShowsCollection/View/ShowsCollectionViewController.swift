//
//  ShowsCollectionViewController.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import UIKit

//TODO: Define a protocol for the VC and expose the shows var
class ShowsCollectionViewController: UIViewController {

    @IBOutlet weak var showsCollectionView: UICollectionView! {
        didSet {
            showsCollectionView.delegate = self
            showsCollectionView.dataSource = self
        }
    }
    
    var shows: [ShowViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.showsCollectionView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Move this OUT of the view controller, use a nice protocol to talk to a presenter or something better.
        let showsDataManager = ShowDataManager()
        showsDataManager.fetchShows { (result) in
            switch (result) {
            case .success(let shows):
                self.shows = shows.map({ ShowViewModel(show: $0) })
                
                //TODO: Organize this!
                //Let's load the poster urls from tmdb.
                let tmdbPosterDataManager = TMDBPosterDataManager()
                shows.forEach({ (show) in
                    tmdbPosterDataManager.fetchPosterUrl(tmdbId: show.serviceIds?.tmdb ?? -1)
                })
//                let tmdbIds = shows.map({ $0.serviceIds?.tmdb })
//                tmdbPosterDataManager.fetchPosterUrl(tmdbIds: tmdbIds)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ShowsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath)
        if let showCollectionViewCell = cell as? ShowCollectionViewCell,
            let show = shows?[indexPath.row] {
            showCollectionViewCell.titleLabel.text = show.title
        }
        return cell
    }
    
}

