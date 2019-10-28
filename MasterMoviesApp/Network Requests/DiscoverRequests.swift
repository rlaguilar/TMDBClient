//
//  DiscoverRequests.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct MoviesDiscoverer {
    private let networkRequester: NetworkRequester
    
    public init(baseURL: URL, apiKey: String) {
        networkRequester = NetworkRequester(baseURL: baseURL, extraParams: ["api_key": apiKey])
    }
    
    func discoverMovies(forDate date: Date, completion: @escaping (Result<[FeaturedContent], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        let theaterRequest = DiscoverTheaterMovies(atDate: date)
        var theaterResult: Result<[Movie], Error>!
        
        dispatchGroup.enter()
        networkRequester.send(request: theaterRequest) { result in
            theaterResult = result
            dispatchGroup.leave()
        }
        
        let comingSoonRequest = DiscoverComingSoonMovies(atDate: date)
        var comingSoonResult: Result<[Movie], Error>!
        
        dispatchGroup.enter()
        networkRequester.send(request: comingSoonRequest) { result in
            comingSoonResult = result
            dispatchGroup.leave()
        }
        
        let popularRequest = DiscoverPopularMovies()
        var popularResult: Result<[Movie], Error>!
        dispatchGroup.enter()
        networkRequester.send(request: popularRequest) { result in
            popularResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            switch (theaterResult!, comingSoonResult!, popularResult!) {
            case let (.success(theater), .success(comingSoon), .success(popular)):
                completion(.success(self.featureContent(theater: theater, comingSoon: comingSoon, popular: popular)))
            case (.failure(let error), _, _):
                completion(.failure(error))
            case (_, .failure(let error), _):
                completion(.failure(error))
            case (_, _, .failure(let error)):
                completion(.failure(error))
            }
        }
    }
    
    func featureContent(theater: [Movie], comingSoon: [Movie], popular: [Movie]) -> [FeaturedContent] {
        var featuredContent: [FeaturedContent] = []
        
        var theater = theater
        
        if let hero = theater.first {
            featuredContent.append(.single(hero))
            theater.removeFirst()
            
            if !theater.isEmpty {
                featuredContent.append(.section(name: "Movies on Theater", movies: Array(theater.prefix(6))))
            }
        }
        
        if !comingSoon.isEmpty {
            featuredContent.append(.section(name: "Coming Soon", movies: Array(comingSoon.prefix(6))))
        }
        
        if !popular.isEmpty {
            featuredContent.append(.section(name: "Popular Movies", movies: Array(popular.prefix(6))))
        }
        
        return featuredContent
    }
}

public struct DiscoverPopularMovies: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init() {
        path = "discover/movie"
        method = .get
        params = ["sort_by": "popularity.desc"]
    }
    
    public func parse(data: Data) throws -> [Movie] {
        let page = try JSONDecoder().decode(ResponsePage<Movie>.self, from: data)
        return page.results
    }
}

public struct DiscoverTheaterMovies: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init(atDate date: Date) {
        path = "discover/movie"
        method = .get
        let oneMonthOldDate = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date
        params = [
            "primary_release_date.gte": oneMonthOldDate.formatedForAPIRequest,
            "primary_release_date.lte": date.formatedForAPIRequest
        ]
    }
    
    public func parse(data: Data) throws -> [Movie] {
        let page = try JSONDecoder().decode(ResponsePage<Movie>.self, from: data)
        return page.results
    }
}

public struct DiscoverComingSoonMovies: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init(atDate date: Date) {
        path = "discover/movie"
        method = .get
        let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        params = [
            "primary_release_date.gte": tomorrowDate.formatedForAPIRequest,
            "primary_release_date.lte": nextMonthDate.formatedForAPIRequest
        ]
    }
    
    public func parse(data: Data) throws -> [Movie] {
        let page = try JSONDecoder().decode(ResponsePage<Movie>.self, from: data)
        return page.results
    }
}

private extension Date {
    var formatedForAPIRequest: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
