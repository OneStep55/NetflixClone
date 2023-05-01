//
//  DownloadsViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 31.03.2023.
//

import UIKit
import PromiseKit

class DownloadsViewController: UIViewController {
    
    var movies = [MovieItem]()
    var tvs = [TVItem]()
    
    
    private let downloadedMoviesTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identififer)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloaded"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(downloadedMoviesTable)
        downloadedMoviesTable.delegate = self
        downloadedMoviesTable.dataSource = self
        fetchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedMoviesTable.frame = view.bounds
    }
    
    private func fetchMovies() {
        DataPersistenceManager.shared.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.downloadedMoviesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        DataPersistenceManager.shared.fetchTVs { [weak self] result in
            switch result {
            case .success(let tvs):
                self?.tvs = tvs
                DispatchQueue.main.async {
                    self?.downloadedMoviesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movies.count
        }
        return tvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identififer, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let model: MovieViewModel
        if indexPath.section == 0 {
            let movie = movies[indexPath.row]
            model = MovieViewModel(title: movie.title ?? "", posterPath: movie.poster_path ?? "")
        } else {
            let tv = tvs[indexPath.count]
            model = MovieViewModel(title: tv.name ?? "", posterPath: tv.poster_path ?? "")
        }
        cell.configure(with: model)
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name: String
        let overview: String
        
        if indexPath.section == 0 {
            let movie = movies[indexPath.row]
            name = movie.title ?? ""
            overview = movie.overview ?? ""
        } else {
            let tv = tvs[indexPath.row]
            name = tv.name ?? ""
            overview = tv.overview ?? ""
        }
        
        firstly {
            APICaller.shared.fetchMovie(query: "\(name) trailer")
        }.done { [weak self] videoElement in
            let model = TitlePreviewViewModel(title: name, description: overview, videoElement: videoElement)
            
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(with: model)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }.catch { error in
            print(error.localizedDescription)
        }
        
        
    }
    
}

