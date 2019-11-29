//
//  DiscoverEndpointsTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

import XCTest
@testable import MasterMoviesApp

class DiscoverEndpointsTests: XCTestCase {
    private let discoverResponseData: Data = {
        let url = Bundle(for: DiscoverEndpointsTests.self).url(forResource: "discover-response", withExtension: "json")!
        return try! Data(contentsOf: url)
    }()
    
    // MARK:- Popular Movies Endpoint
    func testPopularMovies_HasCorrectPath() {
        let endpoint = popularEndpoint()
        
        XCTAssertEqual(endpoint.path, "discover/movie")
    }
    
    func testPopularMovies_HasCorrectMethod() {
        let endpoint = popularEndpoint()
        
        XCTAssertEqual(endpoint.method.text, HTTPMethod.get.text)
    }
    
    func testPopularMovies_ContainsCorrectParams() {
        let endpoint = popularEndpoint()
        
        XCTAssert(endpoint.params["sort_by"] as? String == "popularity.desc")
    }
    
    func testPopularMovies_HasValidParser() throws {
        let endpoint = popularEndpoint()
        
        _ = try endpoint.parser.parse(data: discoverResponseData)
    }
    
    // MARK:- Released Movies Endpoint
    func testReleasedMoviesInRange_HasCorrectPath() {
        let endpoint = releasedMoviesEndpoint(from: Date(), to: Date())
        
        XCTAssertEqual(endpoint.path, "discover/movie")
    }
    
    func testReleasedMoviesInRange_HasCorrectMethod() {
        let endpoint = releasedMoviesEndpoint(from: Date(), to: Date())
        
        XCTAssertEqual(endpoint.method.text, HTTPMethod.get.text)
    }
    
    func testReleasedMoviesInRange_ContainsCorrectParams() {
        let date = Date(timeIntervalSince1970: 0)
        let oneDayAfter = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let endpoint = releasedMoviesEndpoint(from: date, to: oneDayAfter)
        
        XCTAssertEqual(endpoint.params["primary_release_date.gte"] as? String, "1970-01-01")
        XCTAssertEqual(endpoint.params["primary_release_date.lte"] as? String, "1970-01-02")
    }
    
    func testReleasedMoviesInRange_HasValidParser() throws {
        let endpoint = releasedMoviesEndpoint(from: Date(), to: Date())
        
        _ = try endpoint.parser.parse(data: discoverResponseData)
    }
    
    // MARK:- Helper functions
    private func popularEndpoint() -> Endpoint<DiscoverParser> {
        return TMDBApi.Discover.popularMovies()
    }
    
    private func releasedMoviesEndpoint(from: Date, to: Date) -> Endpoint<DiscoverParser> {
        return TMDBApi.Discover.releasedMovies(from: from, to: to)
    }
}
