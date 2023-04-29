//
//  DataPersistenceManager.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 25.04.2023.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
     func saveMovie(model: Movie, comletion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let movieItem = MovieItem(context: context)
        movieItem.id = Int32(model.id)
        movieItem.title = model.title
        movieItem.original_title = model.original_title
        movieItem.overview = model.overview
        movieItem.poster_path = model.poster_path
        
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(error))
        }
    }
    
    
     func saveTV(model: TV, comletion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let tvItem = TVItem(context: context)
        tvItem.id = Int32(model.id)
        tvItem.name = model.name
        tvItem.original_name = model.original_name
        tvItem.overview = model.overview
        tvItem.poster_path = model.poster_path
        
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(error))
        }
    }
    
     func fetchMovies(comletion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            comletion(.success(movies))
        } catch {
            comletion(.failure(error))
        }
    }
    
     func fetchTVs(comletion: @escaping (Result<[TVItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TVItem>
        request = TVItem.fetchRequest()
        
        do {
            let tvs = try context.fetch(request)
            comletion(.success(tvs))
        } catch {
            comletion(.failure(error))
        }
    }
    
     func deleteMovie(movie: MovieItem, comletion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(movie)
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
     func deleteTV(tv: TVItem, comletion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(tv)
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    
}
