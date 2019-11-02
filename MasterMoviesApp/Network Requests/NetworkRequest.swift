//
//  NetworkRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case badRequest
    case badResponse
    case apiError(statusCode: Int, message: String?)
}

public struct Endpoint<Parser: ResponseParser> {
    let path: String
    let method: HTTPMethod
    let params: [String: Any]
    let parser: Parser
}

public protocol ResponseParser {
    associatedtype Response
    
    func parse(data: Data) throws -> Response
}

public protocol RequestBuilder {
    func request<Parser>(for endpoint: Endpoint<Parser>) throws -> URLRequest
}

public enum HTTPMethod {
    case get
    case post([String: Any])
    
    var stringRepresentation: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public class NetworkClient {
    private let builder: RequestBuilder
    
    public init(requestBuilder: RequestBuilder) {
        self.builder = requestBuilder
    }
    
    func request<Parser>(endpoint: Endpoint<Parser>, completion: @escaping (Result<Parser.Response, Error>) -> Void) {
        do {
            try URLSession.shared.dataTask(with: builder.request(for: endpoint)) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.badResponse))
                    return
                }
                
                guard (200 ..< 300).contains(httpResponse.statusCode) else {
                    let message = data.map { String(data: $0, encoding: .utf8) } ?? nil
                    completion(.failure(NetworkError.apiError(statusCode: httpResponse.statusCode, message: message)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.badResponse))
                    return
                }
                
                do {
                    try completion(.success(endpoint.parser.parse(data: data)))
                }
                catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
        catch {
            completion(.failure(error))
        }
    }
}
