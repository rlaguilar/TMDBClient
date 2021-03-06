//
//  APIRequestBuilder.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 25/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public protocol RequestBuilder {
    func request<Parser>(for endpoint: Endpoint<Parser>) throws -> URLRequest
}

public struct APIRequestBuilder: RequestBuilder {
    public static let prod = APIRequestBuilder(
        baseURL: URL(string: "https://api.themoviedb.org/3/")!
    )
    
    public let baseURL: URL
    
    public func request<Parser>(for endpoint: Endpoint<Parser>) throws -> URLRequest {
        var components = URLComponents()
        components.path = endpoint.path
        
        components.queryItems = endpoint.params.map { param -> URLQueryItem in
            URLQueryItem(name: param.key, value: "\(param.value)")
        }
        
        guard let url = components.url(relativeTo: baseURL) else {
            throw NetworkError.badRequest
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = endpoint.method.text
        
        switch endpoint.method {
        case .post(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case .get:
            break
        }
        
        return request as URLRequest
    }
}
