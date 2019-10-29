//
//  NetworkRequestHelpers.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

extension APIRequest {
    func makeRequest(baseURL: URL, extraParams: [String: Any]) throws -> URLRequest {
        let allParams = params.map { $0 } + extraParams.map { $0 }
        var components = URLComponents()
        components.path = path
        
        components.queryItems = allParams.map { param -> URLQueryItem in
            URLQueryItem(name: param.key, value: "\(param.value)")
        }
        
        guard let url = components.url(relativeTo: baseURL) else {
            throw NetworkError.badRequest
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.stringRepresentation
        
        switch method {
        case .post(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case .get:
            break
        }
        
        return request as URLRequest
    }
}

public struct APIRequestWrapper<Request: APIRequest>: NetworkRequest {
    public let apiRequest: Request
    
    public let baseURL: URL
    public let extraParams: [String: Any]
    
    public init(apiRequest: Request) {
        self.apiRequest = apiRequest
        // TODO: Move this to CI configs
        extraParams = ["api_key": "340528aae953e802b9f330ecb5aedbed"]
        baseURL = URL(string: "https://api.themoviedb.org/3/")!
    }
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func makeURLRequest() throws -> URLRequest {
        return try apiRequest.makeRequest(baseURL: baseURL, extraParams: extraParams)
    }
    
    public func parse(data: Data) throws -> Request.Response {
        return try apiRequest.parse(data: data, decoder: jsonDecoder)
    }
}

public extension APIRequest {
    func wrapped() -> APIRequestWrapper<Self> {
        return APIRequestWrapper(apiRequest: self)
    }
}

public extension NetworkClient {
    func send<Request: APIRequest>(request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        send(request: request.wrapped(), completion: completion)
    }
}
