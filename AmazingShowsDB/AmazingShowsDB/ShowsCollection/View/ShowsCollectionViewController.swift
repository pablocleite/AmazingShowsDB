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
    
    func displayError()
}

class ShowsCollectionViewController: UIViewController, ShowCollectionViewProtocol {
    
    static let identifier = "ShowCollectionViewController"
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var showsCollectionView: UICollectionView! {
        didSet {
            showsCollectionView.delegate = self
            showsCollectionView.dataSource = self
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    var presenter: ShowCollectionPresenterProtocol! {
        didSet {
            presenter.view = self
        }
    }
    
    var shows: [ShowViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.hideError()
                self?.refreshControl.endRefreshing()
                self?.showsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateView()
    }
    
    func displayError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.isHidden = false
            self?.refreshControl.endRefreshing()
        }
    }
    
    func hideError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.isHidden = true
        }
    }
    
    func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            showsCollectionView.refreshControl = refreshControl
        } else {
            showsCollectionView.addSubview(refreshControl)
        }
    }
    
    @objc func refresh() {
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

