//
//  APIRequestBuilderTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import XCTest
@testable import MasterMoviesApp

class APIRequestBuilderTests: XCTestCase {
    private let baseURL = URL(string: "https://api.example/version/")!
    lazy var builder = APIRequestBuilder(baseURL: baseURL)

    func testRequest_HasValidSchema() throws {
        let endpoint = createEndpoint()
        
        let request = try buildRequest(for: endpoint)
        
        XCTAssertEqual(request.url!.scheme, baseURL.scheme)
    }
    
    func testRequest_HasValidHost() throws {
        let endpoint = createEndpoint()
        
        let request = try buildRequest(for: endpoint)
        
        XCTAssertEqual(request.url!.host, baseURL.host)
    }
    
    func testRequest_HasValidPath() throws {
        let customPath = "my/path"
        let endpoint = createEndpoint(path: customPath)
        
        let request = try buildRequest(for: endpoint)
        
        let expectedPath = baseURL.appendingPathComponent(customPath).path
        XCTAssertEqual(request.url!.path, expectedPath)
    }
    
    func testRequest_ContainsAdditionalParams() throws {
        let endpoint = createEndpoint()
        let apiKey = "abc"
        
        let request = try buildRequest(for: endpoint, additionalParams: ["api_key": apiKey])

        XCTAssert(request.url!.query!.contains("api_key=\(apiKey)"))
    }
    
    func testRequest_ContainsEndpointParams() throws {
        let params: [String: Any] = ["a": 1, "b": "hello"]
        let endpoint = createEndpoint(withParams: params)
        
        let request = try buildRequest(for: endpoint)
        
        for param in params {
            XCTAssert(request.url!.query!.contains("\(param.key)=\(param.value)"))
        }
    }
    
    func testRequest_MergeEndpointParamsAndAdditionalParams() throws {
        let params: [String: Any] = ["a": 1]
        let additionalParams: [String: Any] = ["b": 2]
        let allParams: [String: Any] = ["a": 1, "b": 2]
        
        let endpoint = createEndpoint(withParams: params)
        
        let request = try buildRequest(for: endpoint, additionalParams: additionalParams)
        
        for param in allParams {
            XCTAssert(request.url!.query!.contains("\(param.key)=\(param.value)"))
        }
    }
    
    func testRequest_WhenAdditionlParamsClashWithEndpointParams_UserAdditionalParamsValue() throws {
        let params: [String: Any] = ["a": 1]
        let additionalParams: [String: Any] = ["a": 2]
        let endpoint = createEndpoint(withParams: params)
        
        let request = try buildRequest(for: endpoint, additionalParams: additionalParams)
        
        XCTAssert(request.url!.query!.contains("a=2"))
        XCTAssert(!request.url!.query!.contains("a=1"))
    }
    
    func testRequest_ForGetEndpoint_HasGetHTTPMethod() throws {
        let endpoint = createEndpoint(method: .get)
        
        let request = try buildRequest(for: endpoint)
        
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testRequest_ForPostEndpoint_HasPostHTTPMethod() throws {
        let endpoint = createEndpoint(method: .post(["key": "value"]))
        
        let request = try buildRequest(for: endpoint)
        
        XCTAssertEqual(request.httpMethod, "POST")
    }
    
    func testRequest_ForPostEndpoint_HasValidHTTPBody() throws {
        let params: [String: Any] = ["key": "value", "key2": 2]
        let endpoint = createEndpoint(method: .post(params))
        
        let request = try buildRequest(for: endpoint)
        let body = try JSONSerialization.jsonObject(with: request.httpBody!, options: []) as! [String: Any]
        
        for (name, value) in params {
            XCTAssertEqual("\(value)", "\(body[name]!)")
        }
    }
    
    private func buildRequest<T>(for endpoint: Endpoint<T>, additionalParams: [String: Any] = [:]) throws -> URLRequest {
        return try builder.request(for: endpoint, additionalParams: additionalParams)
    }
}

private func createEndpoint(method: HTTPMethod = .get, path: String = "", withParams params: [String: Any] = [:]) -> Endpoint<EmptyParser> {
    return Endpoint(path: path, method: method, params: params, parser: EmptyParser())
}

private struct EmptyParser: ResponseParser {
    func parse(data: Data) throws { }
}

