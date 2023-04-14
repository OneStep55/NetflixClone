//
//  APICaller.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 09.04.2023.
//

import Foundation
import PromiseKit


struct Constants {
    static let API_KEY = "94fbfdc3b561adcd992b10798613c46a"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeBaseURL = "https://youtube.googleapis.com"
    static let YoutubeAPI_KEY = "AIzaSyAISuwHK9_MBbeqYhso2eIN3qwfiCru02s"
    
    
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
}
class APICaller {
    static let shared = APICaller()
    
    
    func buildURL(endpoint: String, parameters: [String: String]) throws -> URL {
        var urlComponents = URLComponents(string: "\(Constants.baseURL)\(endpoint)")
        
        urlComponents?.queryItems = parameters.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        return url
    }
    
    func fetchMovies(endpoint: String, paremeters: [String: String]) -> Promise<[Movie]> {
        
        Promise { result in
            do {
                let url = try buildURL(endpoint: endpoint, parameters: paremeters)
                
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                    if let error = error {
                        result.reject(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          200..<300 ~= httpResponse.statusCode else {
                        result.reject(APIError.invalidResponse)
                        return
                    }
                    
                    guard let data = data else {
                        result.reject(APIError.invalidResponse)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(MoivesResponse.self, from: data)
                        result.fulfill(response.results)
                        
                    }catch {
                        result.reject(error)
                    }
                }
                task.resume()
            } catch {
                result.reject(error)
            }
        }
    }
    
    func fetchTrendingMovies() -> Promise<[Movie]> {
        let endpoint = "/3/trending/movie/day"
        let parameters = ["api_key": Constants.API_KEY]
        return fetchMovies(endpoint: endpoint, paremeters: parameters)
    }
    
    func fetchUpcomingMovies() -> Promise<[Movie]> {
        let endpoint = "/3/movie/upcoming"
        let parameters = ["api_key": Constants.API_KEY]
        return fetchMovies(endpoint: endpoint, paremeters: parameters)
    }
    
    func fetchPopularMovies() -> Promise<[Movie]> {
        let endpoint = "/3/movie/popular"
        let parameters = ["api_key": Constants.API_KEY]
        return fetchMovies(endpoint: endpoint, paremeters: parameters)
    }
    
    func fetchTopRatedMovies() -> Promise<[Movie]> {
        let endpoint = "/3/movie/top_rated"
        let parameters = ["api_key": Constants.API_KEY]
        return fetchMovies(endpoint: endpoint, paremeters: parameters)
    }
    func fetchDiscoverMovies() -> Promise<[Movie]> {
        let endpoint = "/3/discover/movie"
        let parameters = ["api_key": Constants.API_KEY, "language": "en-US", "sort_by": "popularity.desc", "include_video": "false", "page": "1", "with_watch_monetization_types": "flatrate"]
        
        return fetchMovies(endpoint: endpoint, paremeters: parameters)
    }
    
    func fetchTrendingTV() -> Promise<[TV]> {
        
        Promise { result in
            let endpoint = "/3/trending/tv/day"
            let parameters = ["api_key": Constants.API_KEY]
            
            do {
                let url = try buildURL(endpoint: endpoint, parameters: parameters)
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    if let error = error {
                        result.reject(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                       200..<300 ~= httpResponse.statusCode else {
                           result.reject(APIError.invalidResponse)
                           return
                    }
                    
                    guard let data = data else {
                        result.reject(APIError.invalidURL)
                        return
                    }
                    
                    do {
                        let res = try JSONDecoder().decode(TVResponse.self, from: data)
                        result.fulfill(res.results)
                    } catch {
                        result.reject(error)
                        return
                    }
                }
                
                task.resume()
                
            } catch {
                result.reject(error)
            }
        }
        
      
    }
    
    
    
  
}
