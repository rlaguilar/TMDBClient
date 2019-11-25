//
//  NetworkClient.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public protocol EndpointModifier {
    func modify<T>(endpoint: Endpoint<T>) -> Endpoint<T>
}

public protocol NetoworkClientObserver {
    func willSend(request: URLRequest)
    
    func didReceiveResponse(for request: URLRequest)
}

public class NetworkClient {
    private let requestBuilder: RequestBuilder
    private let session: URLSession
    private let observer: NetoworkClientObserver
    private let modifier: EndpointModifier
    
    public init(requestBuilder: RequestBuilder,
                session: URLSession = .shared,
                observers: [NetoworkClientObserver],
                modifiers: [EndpointModifier]) {
        
        self.requestBuilder = requestBuilder
        self.session = session
        observer = MergedNetworkClientObserver(observers: observers)
        modifier = MergedEndpointModifier(modifiers: modifiers)
    }
    
    func request<Parser>(endpoint: Endpoint<Parser>, completion: @escaping (Result<Parser.Response, Error>) -> Void) {
        func parseError(fromData data: Data?, response: URLResponse?, error: Error?) -> Error? {
            if let error = error {
                return error
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return NetworkError.badResponse
            }
            
            guard (200 ..< 300).contains(httpResponse.statusCode) else {
                let message = data.map { String(data: $0, encoding: .utf8) } ?? nil
                return NetworkError.apiError(statusCode: httpResponse.statusCode, message: message)
            }
            
            return nil
        }
        
        func parse(data: Data?, response: URLResponse?, error: Error?, parser: Parser) throws -> Parser.Response {
            if let error = parseError(fromData: data, response: response, error: error) {
                throw error
            }
            
            guard let data = data else {
                throw NetworkError.badResponse
            }
            
            return try parser.parse(data: data)
        }
        
        do {
            let request = try requestBuilder.request(for: modifier.modify(endpoint: endpoint))
            observer.willSend(request: request)
            
            session.dataTask(with: request) { [observer] (data, response, error) in
                observer.didReceiveResponse(for: request)
                
                do {
                    let value = try parse(data: data, response: response, error: error, parser: endpoint.parser)
                    completion(.success(value))
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

private class MergedNetworkClientObserver: NetoworkClientObserver {
    private let observers: [NetoworkClientObserver]
    
    public init(observers: [NetoworkClientObserver]) {
        self.observers = observers
    }
    
    public func willSend(request: URLRequest) {
        observers.forEach { $0.willSend(request: request) }
    }
    
    public func didReceiveResponse(for request: URLRequest) {
        for observer in observers {
            observer.didReceiveResponse(for: request)
        }
    }
}

private struct MergedEndpointModifier: EndpointModifier {
    private let modifiers: [EndpointModifier]
    
    public init(modifiers: [EndpointModifier]) {
        self.modifiers = modifiers
    }
    
    public func modify<T>(endpoint: Endpoint<T>) -> Endpoint<T> {
        return modifiers.reduce(endpoint, { modifiedEndpoint, modifier in
            modifier.modify(endpoint: modifiedEndpoint)
        })
    }
}
