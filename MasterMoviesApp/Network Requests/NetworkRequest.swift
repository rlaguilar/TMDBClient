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

public protocol NetworkRequest {
    associatedtype Response
    
    func makeURLRequest() throws -> URLRequest
    
    func parse(data: Data) throws -> Response
}

public protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    
    func parse(data: Data, decoder: JSONDecoder) throws -> Response
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

public struct NetworkClient {
    func send<Request: NetworkRequest>(request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        do {
            try URLSession.shared.dataTask(with: request.makeURLRequest()) { (data, response, error) in
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
                    try completion(.success(request.parse(data: data)))
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
