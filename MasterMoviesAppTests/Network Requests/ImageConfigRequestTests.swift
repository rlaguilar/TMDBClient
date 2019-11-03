//
//  ImageConfigRequestTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

import XCTest
@testable import MasterMoviesApp

class ImageConfigRequestTests: XCTestCase {
    private let configResponseData: Data = {
        let url = Bundle(for: DiscoverEndpointsTests.self).url(forResource: "configuration", withExtension: "json")!
        return try! Data(contentsOf: url)
    }()
    
    private let endpoint = Endpoint.imageConfig()
    
    func testEndpoint_HasCorrectPath() {
        XCTAssertEqual(endpoint.path, "configuration")
    }
    
    func testEndpoint_HasCorrectMethod() {
        XCTAssertEqual(endpoint.method.stringRepresentation, HTTPMethod.get.stringRepresentation)
    }
    
    func testEndpoint_HasValidParser() throws {
        _ = try endpoint.parser.parse(data: configResponseData)
    }
}
