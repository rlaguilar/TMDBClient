//
//  ImageURLBuilderTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 6/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import XCTest
@testable import MasterMoviesApp

class ImageURLBuilderTests: XCTestCase {
    private let sizeConfig = ImageURLBuilder.SizeConfig(posterMinWidth: 20, backdropMinWidth: 30, profileMinWidth: 40)
    private let serverURL = "http://server.com"
    private let imagePath = "image.jpg"
    
    // MARK:- Poster ULR
    func testPosterURL_WhenEqualToAnAvailableWidth_UseThatWidth() throws {
        let apiConfig = APIImageConfig(baseUrl: serverURL, backdropSizes: [], posterSizes: ["w10", "w20", "w30"], profileSizes: [])
        let urlBuilder = ImageURLBuilder(usingAPIConfig: apiConfig, sizeConfig: sizeConfig)!
        
        let url = urlBuilder.url(forPosterPath: imagePath)
        
        XCTAssertEqual(url, buildURL(width: "w20"))
    }
    
    func testPosterURL_WhenSmallerThanAvailableWidth_UseThatWidth() throws {
        let apiConfig = APIImageConfig(baseUrl: serverURL, backdropSizes: [], posterSizes: ["w25", "w30"], profileSizes: [])
        let urlBuilder = ImageURLBuilder(usingAPIConfig: apiConfig, sizeConfig: sizeConfig)!
        
        let url = urlBuilder.url(forPosterPath: imagePath)
        
        XCTAssertEqual(url, buildURL(width: "w25"))
    }
    
    func testPosterURL_WhenBiggerThanAllAvailableWidths_ReturnsNil() throws {
        let apiConfig = APIImageConfig(baseUrl: serverURL, backdropSizes: [], posterSizes: ["w15"], profileSizes: [])
        let urlBuilder = ImageURLBuilder(usingAPIConfig: apiConfig, sizeConfig: sizeConfig)!
        
        let url = urlBuilder.url(forPosterPath: imagePath)
        
        XCTAssertEqual(url, nil)
    }
    
    func testPosterURL_WhenBiggerThanAllAvailableWidthsButOriginal_ReturnsOriginal() throws {
        let apiConfig = APIImageConfig(baseUrl: serverURL, backdropSizes: [], posterSizes: ["w15", "original"], profileSizes: [])
        let urlBuilder = ImageURLBuilder(usingAPIConfig: apiConfig, sizeConfig: sizeConfig)!
        
        let url = urlBuilder.url(forPosterPath: imagePath)
        
        XCTAssertEqual(url, buildURL(width: "original"))
    }
    
    private func buildURL(width: String) -> URL {
        return URL(string: serverURL)!.appendingPathComponent(width).appendingPathComponent(imagePath)
    }
}
