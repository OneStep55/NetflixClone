//
//  MovieTableViewCell.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 13.04.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identififer = "MovieTableViewCell"
    let moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let movieTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
        contentView.addSubview(playButton)
        configureConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstrains() {
        let moviePosterConstrains = [
            moviePoster.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePoster.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            moviePoster.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            moviePoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        let movieTitleConstrains = [
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            movieTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        let playButtonConstrains = [
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ]
        
        NSLayoutConstraint.activate(moviePosterConstrains)
        NSLayoutConstraint.activate(movieTitleConstrains)
        NSLayoutConstraint.activate(playButtonConstrains)
    }
    
    func configure(with model: MovieViewModel) {
        
        movieTitle.text = model.title
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)") else {return}
        
        moviePoster.sd_setImage(with: url)
    }
}
