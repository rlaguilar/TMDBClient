//
//  DiscoverEndpoints.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public extension Endpoint where Parser == DiscoverParser {
    struct Discover {
        static func popularMovies() -> Endpoint {
            return Endpoint(path: "discover/movie", method: .get, params: ["sort_by": "popularity.desc"], parser: DiscoverParser())
        }
        
        static func theaterMovies(at date: Date) -> Endpoint {
            let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date
            return releasedMovies(from: oneMonthBefore, to: date)
        }
        
        static func comingSoonMovies(at date: Date) -> Endpoint {
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
            let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
            return releasedMovies(from: nextDay, to: oneMonthLater)
        }
        
        static private func releasedMovies(from: Date, to: Date) -> Endpoint {
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
