//
//  NetworkRequestHelpers.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct APIRequestMaker: URLRequestMaker {
    public static let prod = APIRequestMaker(
        baseURL: URL(string: "https://api.themoviedb.org/3/")!,
        apiKey: "340528aae953e802b9f330ecb5aedbed"
    )
    
    public let baseURL: URL
    public let apiKey: String
    
    public func request(for endpoint: Endpoint) throws -> URLRequest {
        var params = endpoint.params
        params["api_key"] = apiKey
        
        var components = URLComponents()
        components.path = endpoint.path
        
        components.queryItems = params.map { param -> URLQueryItem in
            URLQueryItem(name: param.key, value: "\(param.value)")
        }
        
        guard let url = components.url(relativeTo: baseURL) else {
            throw NetworkError.badRequest
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = endpoint.method.stringRepresentation
        
        switch endpoint.method {
        case .post(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case .get:
            break
        }
        
        return request as URLRequest
    }
}

public struct APIReponseParser<Value: Decodable>: ResponseParser {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func parse(response: Data) throws -> Value {
        return try decoder.decode(Value.self, from: response)
    }
}
