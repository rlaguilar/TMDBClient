//
//  APIResponseParserTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import XCTest
@testable import MasterMoviesApp

class APIResponseParserTests: XCTestCase {
    func testParse_HandleSnakeCase() throws {
        let parser = APIReponseParser<SnakeCasePage>()
        let fileURL = Bundle(for: type(of: self)).url(forResource: "sample-page", withExtension: "json")!
        let data = try Data(contentsOf: fileURL)
        
        let page = try parser.parse(data: data)
        
        XCTAssertEqual(page.totalResults, 2)
    }
}

private struct SnakeCasePage: Codable {
    let totalResults: Int
}
