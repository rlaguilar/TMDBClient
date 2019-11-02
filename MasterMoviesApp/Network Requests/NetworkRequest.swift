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

public struct Endpoint {
    let path: String
    let method: HTTPMethod
    let params: [String: Any]
}

public protocol URLRequestMaker {
    func request(for endpoint: Endpoint) throws -> URLRequest
}

public protocol ResponseParser {
    associatedtype Value
    
    func parse(response: Data) throws -> Value
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
    private let requestMaker: URLRequestMaker
    
    public init(requestMaker: URLRequestMaker) {
        self.requestMaker = requestMaker
    }
    
    func request<Parser: ResponseParser>(endpoint: Endpoint, parser: Parser, completion: @escaping (Result<Parser.Value, Error>) -> Void) {
        do {
            try URLSession.shared.dataTask(with: requestMaker.request(for: endpoint)) { (data, response, error) in
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
                    try completion(.success(parser.parse(response: data)))
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
