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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK:- Popular Movies Endpoint
    func testPopularMovies_HasCorrectPath() {
        let endpoint = Endpoint.Discover.popularMovies()
        
        XCTAssertEqual(endpoint.path, "discover/movie")
    }
    
    func testPopularMovies_HasCorrectMethod() {
        let endpoint = Endpoint.Discover.popularMovies()
        
        XCTAssertEqual(endpoint.method.stringRepresentation, HTTPMethod.get.stringRepresentation)
    }
    
    func testPopularMovies_ContainsCorrectParams() {
        let endpoint = Endpoint.Discover.popularMovies()
        
        XCTAssert(endpoint.params["sort_by"] as? String == "popularity.desc")
    }
    
    func testPopularMovies_HasValidParser() throws {
        let endpoint = Endpoint.Discover.popularMovies()
        
        _ = try endpoint.parser.parse(data: discoverResponseData)
    }
    
    // MARK:- Theater Movies Endpoint
    func testTheaterMovies_HasCorrectPath() {
        let endpoint = Endpoint.Discover.theaterMovies(at: Date())
        
        XCTAssertEqual(endpoint.path, "discover/movie")
    }
    
    func testTheaterMovies_HasCorrectMethod() {
        let endpoint = Endpoint.Discover.theaterMovies(at: Date())
        
        XCTAssertEqual(endpoint.method.stringRepresentation, HTTPMethod.get.stringRepresentation)
    }
    
    func testTheaterMovies_ContainsCorrectParams() {
        let date = Date(timeIntervalSince1970: 0)
        let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        let endpoint = Endpoint.Discover.theaterMovies(at: date)
        
        XCTAssertEqual(endpoint.params["primary_release_date.gte"] as? String, dateFormatter.string(from: oneMonthBefore))
        XCTAssertEqual(endpoint.params["primary_release_date.lte"] as? String, dateFormatter.string(from: date))
    }
    
    func testTheaterMovies_HasValidParser() throws {
        let endpoint = Endpoint.Discover.comingSoonMovies(at: Date())
        
        _ = try endpoint.parser.parse(data: discoverResponseData)
    }
    
    // MARK:- Coming Soon Movies Endpoint
    func testComingSoonMovies_HasCorrectPath() {
        let endpoint = Endpoint.Discover.comingSoonMovies(at: Date())
        
        XCTAssertEqual(endpoint.path, "discover/movie")
    }
    
    func testComingSoonMovies_HasCorrectMethod() {
        let endpoint = Endpoint.Discover.theaterMovies(at: Date())
        
        XCTAssertEqual(endpoint.method.stringRepresentation, HTTPMethod.get.stringRepresentation)
    }
    
    func testComingSoonMovies_ContainsCorrectParams() {
        let date = Date(timeIntervalSince1970: 0)
        let oneDayLater = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let oneMonthAfter = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        let endpoint = Endpoint.Discover.comingSoonMovies(at: date)
        
        XCTAssertEqual(endpoint.params["primary_release_date.gte"] as? String, dateFormatter.string(from: oneDayLater))
        XCTAssertEqual(endpoint.params["primary_release_date.lte"] as? String, dateFormatter.string(from: oneMonthAfter))
    }
    
    func testComingSoonMovies_HasValidParser() throws {
        let endpoint = Endpoint.Discover.comingSoonMovies(at: Date())
        
        _ = try endpoint.parser.parse(data: discoverResponseData)
    }
}
