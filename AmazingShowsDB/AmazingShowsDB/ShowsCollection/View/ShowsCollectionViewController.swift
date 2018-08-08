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
    
    static let identifier = "ShowCollectionViewController"
    
    @IBOutlet weak var showsCollectionView: UICollectionView! {
        didSet {
            showsCollectionView.delegate = self
            showsCollectionView.dataSource = self
        }
    }
    
    var presenter: ShowCollectionPresenterProtocol! {
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
            showCollectionViewCell.posterImageView.kf.setImage(with: show.posterUrl, placeholder: #imageLiteral(resourceName: "posterPlaceholder"))
        }
        return cell
    }
    
}

