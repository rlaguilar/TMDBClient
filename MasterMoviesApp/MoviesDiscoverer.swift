//
//  MoviesDiscoverer.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct MoviesDiscoverer {
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    func discoverMovies(forDate date: Date, completion: @escaping (Result<[FeaturedContent], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        var theaterResult: Result<[Movie], Error>!
        dispatchGroup.enter()
        client.request(endpoint: Endpoint.Discover.theaterMovies(at: date)) { result in
            theaterResult = result
            dispatchGroup.leave()
        }
        
        var comingSoonResult: Result<[Movie], Error>!
        
        dispatchGroup.enter()
        client.request(endpoint: Endpoint.Discover.comingSoonMovies(at: date)) { result in
            comingSoonResult = result
            dispatchGroup.leave()
        }
        
        var popularResult: Result<[Movie], Error>!
        
        dispatchGroup.enter()
        client.request(endpoint: Endpoint.Discover.popularMovies()) { result in
            popularResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            switch (theaterResult!, comingSoonResult!, popularResult!) {
            case let (.success(theater), .success(comingSoon), .success(popular)):
                completion(.success(FeaturedContent.from(theater: theater, comingSoon: comingSoon, popular: popular)))
            case (.failure(let error), _, _):
                completion(.failure(error))
            case (_, .failure(let error), _):
                completion(.failure(error))
            case (_, _, .failure(let error)):
                completion(.failure(error))
            }
        }
    }
}

private extension FeaturedContent {
    static func from(theater: [Movie], comingSoon: [Movie], popular: [Movie]) -> [FeaturedContent] {
        func single(from items: [Movie]) -> FeaturedContent? {
            guard let movie = items.first else { return nil }
            
            return .single(movie)
        }
        
        func section(from items: [Movie], title: String, skipping: Int = 0) -> FeaturedContent? {
            guard items.count > skipping else { return nil }
            
            return .section(name: title, movies: Array(items.suffix(items.count - skipping).suffix(6)))
        }
        
        return [
            single(from: theater),
            section(from: theater, title: "Movies on Theater", skipping: 1),
            section(from: comingSoon, title: "Coming Soon"),
            section(from: popular, title: "Popular Movies")
            ].compactMap { $0 }
    }
}
