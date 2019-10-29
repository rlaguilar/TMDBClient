//
//  DiscoverRequests.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct DiscoverPopularMovies: APIRequest {
    public let path: String
    public let method: HTTPMethod
    public let params: [String : Any]
    
    public init() {
        path = "discover/movie"
        method = .get
        params = ["sort_by": "popularity.desc"]
    }
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> [Movie] {
        let page = try decoder.decode(PageResponse<Movie>.self, from: data)
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
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> [Movie] {
        let page = try decoder.decode(PageResponse<Movie>.self, from: data)
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
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> [Movie] {
        let page = try decoder.decode(PageResponse<Movie>.self, from: data)
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
