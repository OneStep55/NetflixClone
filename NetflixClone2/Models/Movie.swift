//
//  Movie.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 09.04.2023.
//

import Foundation


struct MoivesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let original_title: String?
    let title: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let vote_average: Double
    let release_date: String?
    
}
