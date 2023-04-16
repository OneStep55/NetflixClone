//
//  YoutubeSearchResponce.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 16.04.2023.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IDElement
}
struct IDElement: Codable {
    let videoId: String
    let kind: String
}
