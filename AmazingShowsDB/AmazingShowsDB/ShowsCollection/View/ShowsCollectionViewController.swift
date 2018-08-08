//
//  ShowsCollectionViewController.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import UIKit
import Kingfisher

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
  
  var interactor: ShowsCollectionInteractor! {
    didSet {
      interactor.delegate = self
    }
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = ShowsCollectionInteractor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Move this OUT of the view controller, use a nice protocol to talk to a presenter or something better.
      interactor.loadShows()
    }

  

}

extension ShowsCollectionViewController: ShowsCollectionInteractorDelegate {
  func didFinishLoadingShows(shows: [ShowViewModel]) {
    self.shows = shows
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
            showCollectionViewCell.posterImageView.kf.indicatorType = .activity
            showCollectionViewCell.posterImageView.kf.setImage(with: show.posterUrl)
        }
        return cell
    }
    
}

