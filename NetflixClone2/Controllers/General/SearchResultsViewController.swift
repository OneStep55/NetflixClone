//
//  SearchResultsViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 14.04.2023.
//

import UIKit
import PromiseKit

protocol SearchResultsViewControllerDelegate {
    func didSelectCellItem(model: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    var movies = [Movie]()
    var delegate: SearchResultsViewControllerDelegate?
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        
        let title = movie.title ?? ""
        
        firstly {
            APICaller.shared.fetchMovie(query: "\(title) trailer")
        }.done { [weak self] videoElement in
            let model = TitlePreviewViewModel(
                title: title,
                description: movie.overview ?? "",
                videoElement: videoElement)
            
            self?.delegate?.didSelectCellItem(model: model)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    
    
}
