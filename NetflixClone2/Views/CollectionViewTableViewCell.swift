//
//  CollectionViewTableViewCell.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 31.03.2023.
//

import UIKit
import PromiseKit

protocol CollectionViewTableViewCellDelegate {
    func didTapCellItem(model: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    var delegate: CollectionViewTableViewCellDelegate?
    var movies = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.moviesCollection.reloadData()
            }
        }
    }
    var tvs = [TV]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.moviesCollection.reloadData()
            }
        }
    }
    
    private let moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            TitleCollectionViewCell.self  ,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        moviesCollection.delegate = self
        moviesCollection.dataSource = self
        contentView.addSubview(moviesCollection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moviesCollection.frame = contentView.bounds
    }
    
    func configure(movies: [Movie]) {
        self.movies = movies
    }
    func configure(tvs: [TV]) {
        self.tvs = tvs
    }
    
    func saveTitle(indexPath: IndexPath){
        print(movies[indexPath.row].title)
    }

}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movies.isEmpty {
            return tvs.count
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        var url: String
        if movies.isEmpty {
             url = tvs[indexPath.row].poster_path ?? ""
        } else {
            url = movies[indexPath.row].poster_path ?? ""
        }
        cell.configure(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title: String
        let description: String
        
        if movies.isEmpty {
            title = tvs[indexPath.row].name
            description = tvs[indexPath.row].overview ?? ""
        } else {
            title = movies[indexPath.row].title ?? ""
            description = movies[indexPath.row].overview ?? ""
        }
        
        firstly {
            APICaller.shared.fetchMovie(query: "\(title) trailer")
        }.done { [weak self] videoElement in
            let model = TitlePreviewViewModel(title: title, description: description, videoElement: videoElement)
            self?.delegate?.didTapCellItem(model: model)
        }.catch { error in
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider:  { _ in
            let dowloandAction = UIAction(title: "download") { [weak self] _ in
                self?.saveTitle(indexPath: indexPaths[0])
            }
            
            return UIMenu(options: .displayInline, children: [dowloandAction])
        })
        return config
    }
    
}
