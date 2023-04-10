//
//  HeroHeaderView.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 01.04.2023.
//

import UIKit

class HeroHeaderView: UIView {
    
    let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 5
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImage)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        configureConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImage.frame = self.bounds
    }
    
    func addGradient () {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    func configureConstrains() {
        let playButtonConstrains = [
            playButton.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 45),
            playButton.bottomAnchor.constraint(equalTo: super.bottomAnchor, constant: -15),
            playButton.widthAnchor.constraint(equalToConstant: 125)
        ]
        let downloandButtonConstrains = [
            downloadButton.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: -45),
            downloadButton.bottomAnchor.constraint(equalTo: super.bottomAnchor, constant: -15),
            downloadButton.widthAnchor.constraint(equalToConstant: 125)
        ]
        
        
        NSLayoutConstraint.activate(playButtonConstrains)
        NSLayoutConstraint.activate(downloandButtonConstrains)
    }
    
    func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {return}
        heroImage.sd_setImage(with: url)
    }
    
}
