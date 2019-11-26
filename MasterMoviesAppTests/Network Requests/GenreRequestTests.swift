//
//  GenreRequestTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import XCTest
@testable import MasterMoviesApp

class GenreRequestTests: XCTestCase {
    private let genresResponseData: Data = {
        let url = Bundle(for: DiscoverEndpointsTests.self).url(forResource: "movie-genres", withExtension: "json")!
        return try! Data(contentsOf: url)
    }()
    
    private let endpoint = TMDBApi.movieGenres()
    
    func testEndpoint_HasCorrectPath() {
        XCTAssertEqual(endpoint.path, "genre/movie/list")
    }
    
    func testEndpoint_HasCorrectMethod() {
        XCTAssertEqual(endpoint.method.text, HTTPMethod.get.text)
    }
    
    func testEndpoint_HasValidParser() throws {
        _ = try endpoint.parser.parse(data: genresResponseData)
    }
}
