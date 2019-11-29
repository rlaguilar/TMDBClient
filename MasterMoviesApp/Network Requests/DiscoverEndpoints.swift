//
//  DiscoverEndpoints.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public enum TMDBApi { }

public extension TMDBApi {
    struct Discover {
        static func popularMovies() -> Endpoint<DiscoverParser> {
            return Endpoint(path: "discover/movie", method: .get, params: ["sort_by": "popularity.desc"], parser: DiscoverParser())
        }
        
        static func releasedMovies(from: Date, to: Date) -> Endpoint<DiscoverParser> {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return Endpoint(
                path: "discover/movie",
                method: .get,
                params: [
                    "primary_release_date.gte": formatter.string(from: from),
                    "primary_release_date.lte": formatter.string(from: to)
                ],
                parser: DiscoverParser()
            )
        }
    }
}

public struct DiscoverParser: ResponseParser {
    private let pageReponseParser = APIReponseParser<PageResponse<Movie>>()
    
    public func parse(data: Data) throws -> [Movie] {
        return try pageReponseParser.parse(data: data).results
    }
}

public struct ReleaseMoviesRange {
    public let from: Date
    public let to: Date
    
    public init(moviesInTheatersForDate date: Date) {
        from = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date
        to = date
    }
    
    public init(comingSoonMoviesForDate date: Date) {
        from = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        to = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
    }
}
