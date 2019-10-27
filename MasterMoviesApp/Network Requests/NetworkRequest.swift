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
    case apiError(error: Error, message: String)
}

public protocol APIRequest {
    associatedtype ResponseType
    
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    
    func parse(data: Data) throws -> ResponseType
}

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
        return request as URLRequest
    }
}

public struct NetworkRequester {
    public let baseURL: URL
    public let extraParams: [String: Any]
    
    func send<Request: APIRequest>(request: Request, completion: @escaping (Result<Request.ResponseType, Error>) -> Void) {
        do {
            let urlRequest = try request.makeRequest(baseURL: baseURL, extraParams: extraParams)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if let error = error {
                    if let data = data, let apiMessage = String(data: data, encoding: .utf8) {
                        completion(.failure(NetworkError.apiError(error: error, message: apiMessage)))
                    }
                    else {
                        completion(.failure(error))
                    }
                }
                else {
                    guard let data = data else {
                        completion(.failure(NetworkError.badResponse))
                        return
                    }
                    
                    do {
                        let result = try request.parse(data: data)
                        completion(.success(result))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
            }
            
            task.resume()
        }
        catch {
            completion(.failure(error))
        }
    }
}

public enum HTTPMethod {
    case get
    case post([String: AnyHashable])
    
    var stringRepresentation: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public struct ResponsePage<T: Codable>: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [T]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
