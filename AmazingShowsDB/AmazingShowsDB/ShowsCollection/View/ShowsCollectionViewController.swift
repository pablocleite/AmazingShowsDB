//
//  ShowsCollectionViewController.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import UIKit
import Kingfisher

protocol ShowCollectionViewProtocol {
  var presenter: ShowCollectionPresenterProtocol! { get set }
  var shows: [ShowViewModel]? {get set}
}

class ShowsCollectionViewController: UIViewController, ShowCollectionViewProtocol {

    @IBOutlet weak var showsCollectionView: UICollectionView! {
        didSet {
            showsCollectionView.delegate = self
            showsCollectionView.dataSource = self
        }
    }
    

  //TODO: use dependency injection here!
  var presenter: ShowCollectionPresenterProtocol! = ShowCollectionPresenter() {
    didSet {
      presenter.view = self
    }
  }
  
  var shows: [ShowViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.showsCollectionView.reloadData()
            }
        }
    }
  
  //TODO: Remove method below after DI
  override func viewDidLoad() {
    presenter.view = self
  }
    
    override func viewWillAppear(_ animated: Bool) {
      presenter.updateView()
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
          //TODO: Set a placeholder image
            showCollectionViewCell.posterImageView.kf.setImage(with: show.posterUrl)
        }
        return cell
    }
    
}

