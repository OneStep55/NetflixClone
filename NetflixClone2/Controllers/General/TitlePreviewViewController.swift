//
//  TitlePreviewViewController.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 15.04.2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(webView)
        contentView.addSubview(movieTitle)
        contentView.addSubview(movieDescription)
        contentView.addSubview(downloadButton)
        configureConstains()
    }
    
    func configureConstains(){
        
        let sf = scrollView.frameLayoutGuide
        let sa = scrollView.contentLayoutGuide
        let scrollViewConstrains = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let contentViewConstrains = [
            contentView.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: sa.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: sa.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: sf.widthAnchor)
        ]
        
        let webViewConstrains = [
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let movieTitleConstrains = [
            movieTitle.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 15),
            movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)]
        
        let movieDescriptionConstrains = [
            movieDescription.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 10),
            movieDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        let downloadButtonConstrains = [
            downloadButton.topAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: 15),
            downloadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
       
        
        NSLayoutConstraint.activate(scrollViewConstrains)
        NSLayoutConstraint.activate(contentViewConstrains)
        NSLayoutConstraint.activate(webViewConstrains)
        NSLayoutConstraint.activate(movieTitleConstrains)
        NSLayoutConstraint.activate(movieDescriptionConstrains)
        NSLayoutConstraint.activate(downloadButtonConstrains)
    }
    
    func configure(with model: TitlePreviewViewModel) {
        movieTitle.text = model.title
        movieDescription.text = model.description
        
        if let url = URL(string: "https://youtube.com/embed/\(model.videoElement.id.videoId)") {
            webView.load(URLRequest(url: url))
        }
    }
    
    
}
