//
//  NetworkClientTests.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

import XCTest
@testable import MasterMoviesApp

class NetworkClientTests: XCTestCase {
    private let mockURL = URL(string: "https://api.myserver.com/v2/")!
    private lazy var mockRequestBuilder = MockRequestBuilder(request: URLRequest(url: mockURL))
    private let endpoint = Endpoint(path: "", method: .get, params: [:], parser: StringParser())
    
    private lazy var client: NetworkClient = {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return NetworkClient(requestBuilder: mockRequestBuilder, session: session, observers: [], modifiers: [])
    }()
    
    func testClient_PerformsCorrectURLRequest() {
        MockURLProtocol.response = .success(NetworkResult(url: mockURL))
        let requestFinished = expectation(description: "Waiting for request to finish")
        
        client.request(endpoint: endpoint) { _ in
            requestFinished.fulfill()
        }
        wait(for: [requestFinished], timeout: 1)
        
        XCTAssertEqual(MockURLProtocol.targetRequest, mockRequestBuilder.request)
    }
    
    func testClient_WhenThereIsAnErrorResponse_ReturnsError() {
        let expectedError = MockError.someError
        MockURLProtocol.response = .failure(expectedError)
        let requestFinished = expectation(description: "Waiting for request to finish")
        
        client.request(endpoint: endpoint) { result in
            switch result {
            case .success(let value):
                XCTFail("Expecting error but got value: \(value)")
            case .failure(let error):
                XCTAssertEqual(error as? MockError, expectedError)
            }
            
            requestFinished.fulfill()
        }
        
        wait(for: [requestFinished], timeout: 1)
    }
    
    func testClient_WhenThereIsANonSuccessStatusCode_ReturnsNetworkError() throws {
        let statusCode = 401
        let data = try JSONEncoder().encode("Not Authorized")
        let expectedError = NetworkError.apiError(statusCode: statusCode, message: String(data: data, encoding: .utf8))
        MockURLProtocol.response = .success(NetworkResult(url: mockURL, data: data, code: statusCode))
        let requestFinished = expectation(description: "Waiting for request to finish")
        
        client.request(endpoint: endpoint) { result in
            switch result {
            case .success(let response):
                XCTFail("Expecting error but got value: \(response)")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, expectedError)
            }
            
            requestFinished.fulfill()
        }
        
        wait(for: [requestFinished], timeout: 1)
    }
    
    func testClient_WhenThereIsASuccessfulResponse_UseEndpointParser() throws {
        let expectedResponse = "Hello, world!"
        let data = try JSONEncoder().encode(expectedResponse)
        MockURLProtocol.response = .success(NetworkResult(url: mockURL, data: data))
        let requestFinished = expectation(description: "Waiting for request to finish")
        
        client.request(endpoint: endpoint) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, expectedResponse)
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            requestFinished.fulfill()
        }
        
        wait(for: [requestFinished], timeout: 1)
    }
}

private struct MockRequestBuilder: RequestBuilder {
    let request: URLRequest
    
    func request<Parser>(for endpoint: Endpoint<Parser>) throws -> URLRequest {
        return request
    }
}

private struct StringParser: ResponseParser {
    func parse(data: Data) throws -> String {
        return try JSONDecoder().decode(String.self, from: data)
    }
}

private enum MockError: Error {
    case someError
}
