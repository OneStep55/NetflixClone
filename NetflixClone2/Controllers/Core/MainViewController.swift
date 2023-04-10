//
//  ViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 31.03.2023.
//

import UIKit
import PromiseKit




class MainViewController: UIViewController {
    
    enum Sections: Int {
        case trendingMovies
        case tredingTV
        case popular
        case upcoming
        case topRated
    }
    
    private let moviesCollectionTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            CollectionViewTableViewCell.self ,
            forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    var headerView: HeroHeaderView?
    
    let sectionNames = ["Trending Moives", "Trending TV", "Upcoming movies", "Popular", "Top rated"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        moviesCollectionTable.delegate = self
        moviesCollectionTable.dataSource = self
        view.addSubview(moviesCollectionTable)
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 420))
        moviesCollectionTable.tableHeaderView = headerView
        
        configureNavbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moviesCollectionTable.frame = view.bounds
    }
    
    private func configureHeader(with movie: Movie) {
        headerView?.configure(with: movie.poster_path ?? "")
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
    }
    



}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier,
            for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            firstly {
                APICaller.shared.fetchTrendingMovies()
            }.done {[weak self] movies in
                cell.configure(movies: movies)
                if let movie = movies.randomElement() {
                    self?.configureHeader(with: movie)
                }
               
            }.catch { error in
                print(error.localizedDescription)
            }
        case Sections.tredingTV.rawValue:
            firstly {
                APICaller.shared.fetchTrendingTV()
            }.done { tvs in
                cell.configure(tvs: tvs)
            }.catch { error in
                print(error.localizedDescription)
            }
        case Sections.upcoming.rawValue:
            firstly {
                APICaller.shared.fetchUpcomingMovies()
            }.done { movies in
                cell.configure(movies: movies)
            }.catch { error in
                print(error)
            }
        case Sections.popular.rawValue:
            firstly {
                APICaller.shared.fetchPopularMovies()
            }.done { movies in
                cell.configure(movies: movies)
            }.catch { error in
                print(error)
            }
        case Sections.topRated.rawValue:
            firstly {
                APICaller.shared.fetchTopRatedMovies()
            }.done { movies in
                cell.configure(movies: movies)
            }.catch { error in
                print(error)
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        header.textLabel?.text = header.textLabel?.text?.captitilizeFirstLetter()
        header.textLabel?.textColor = .label
    }
    
}

