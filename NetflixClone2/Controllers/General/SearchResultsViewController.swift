//
//  SearchResultsViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 14.04.2023.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var movies = [Movie]()
    
    let searchResultsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3  - 10, height: 170)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collection
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsCollection.dataSource = self
        searchResultsCollection.delegate = self
        view.addSubview(searchResultsCollection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollection.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.row].poster_path ?? "")
        return cell
    }
    
    
}
