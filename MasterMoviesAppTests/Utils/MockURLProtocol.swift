//
//  MockURLProtocol.swift
//  MasterMoviesAppTests
//
//  Created by Reynaldo Aguilar on 3/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var targetRequest: URLRequest?
    
    static var response: Result<NetworkResult, Error>?
    
    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        
        MockURLProtocol.targetRequest = request
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let response = MockURLProtocol.response else {
            fatalError("Response isn't set")
        }
    
        switch response {
        case .success(let networkResult):
            client?.urlProtocol(self, didReceive: networkResult.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: networkResult.data)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}

struct NetworkResult {
    let data: Data
    let response: HTTPURLResponse
    
    init(url: URL, data: Data = Data(), code: Int = 200) {
        self.data = data
        self.response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}
