//
//  TV.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 09.04.2023.
//

import Foundation

struct TVResponse: Codable {
    let results: [TV]
}

struct TV: Codable {
    let id: Int
    let name: String
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let first_air_date: String?
    let vote_average: Double
    let vote_count: Int
}
