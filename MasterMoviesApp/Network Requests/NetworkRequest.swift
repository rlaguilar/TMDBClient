//
//  NetworkRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public enum NetworkError: Error, Equatable {
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
    func request<Parser>(for endpoint: Endpoint<Parser>, additionalParams: [String: Any]) throws -> URLRequest
}

public protocol RequestHelper {
    var additionalParams: [String: Any] { get }
    
    func willSend(request: URLRequest)
    
    func didReceiveResponse(for request: URLRequest)
}

public struct MergedRequestHelper: RequestHelper {
    private let helpers: [RequestHelper]
    
    public var additionalParams: [String : Any] {
        return self.helpers
            .map { $0.additionalParams }
            .reduce([:]) { union, params -> [String: Any] in
                union.merging(params, uniquingKeysWith: { _, new in new })
            }
    }
    
    public init(helpers: [RequestHelper]) {
        self.helpers = helpers
    }
    
    public func willSend(request: URLRequest) {
        for helper in helpers {
            helper.willSend(request: request)
        }
    }
    
    public func didReceiveResponse(for request: URLRequest) {
        for helper in helpers {
            helper.didReceiveResponse(for: request)
        }
    }
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
    private let session: URLSession
    private let helper: RequestHelper
    
    public init(requestBuilder: RequestBuilder, session: URLSession = .shared, helpers: RequestHelper...) {
        self.builder = requestBuilder
        self.session = session
        helper = MergedRequestHelper(helpers: helpers)
    }
    
    func request<Parser>(endpoint: Endpoint<Parser>, completion: @escaping (Result<Parser.Response, Error>) -> Void) {
        do {
            let request = try builder.request(for: endpoint, additionalParams: helper.additionalParams)
            helper.willSend(request: request)
            
            session.dataTask(with: request) { [helper] (data, response, error) in
                helper.didReceiveResponse(for: request)
                
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
