//
//  SearchViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 31.03.2023.
//

import UIKit
import PromiseKit
class SearchViewController: UIViewController {
    
    var movies = [Movie]()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search a Movie or TV show"
        searchController.searchBar.barStyle = .default
        return searchController
    }()

    
    let moviesTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identififer)
       
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        moviesTable.delegate = self
        moviesTable.dataSource = self
        view.addSubview(moviesTable)
        fetchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moviesTable.frame = view.bounds
    }
    
    func fetchMovies() {
        firstly {
            APICaller.shared.fetchDiscoverMovies()
        }.done { [weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.moviesTable.reloadData()
            }
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    

   

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identififer, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(title: movie.title ?? "", posterPath: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        let title = movie.title ?? ""
        firstly {
            APICaller.shared.fetchMovie(query: ("\(title) trailer"))
        }.done { [weak self] videoElement in
            let model = TitlePreviewViewModel(title: title, description: movie.overview ?? "", videoElement: videoElement)
            
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

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {
            return
        }
        
        resultsController.delegate = self
        
        firstly {
            APICaller.shared.searchMovie(query: query)
        }.done { movies in
            resultsController.movies = movies
            
            DispatchQueue.main.async {
                resultsController.searchResultsCollection.reloadData()
            }
        
        }.catch { error in
            print(error)
        }
    }
}
extension SearchViewController: SearchResultsViewControllerDelegate {
    func didSelectCellItem(model: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
