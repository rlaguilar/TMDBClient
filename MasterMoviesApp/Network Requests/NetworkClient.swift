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
    
    func didFinishLoadingContent(for request: URLRequest, data: Data, response: HTTPURLResponse)
    
    func didFailLoadingContent(for request: URLRequest, withError error: Error)
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
    
    public func request<Parser>(endpoint: Endpoint<Parser>, completion: @escaping (Result<Parser.Response, Error>) -> Void) {
        func parseError(fromData data: Data, response: HTTPURLResponse) -> Error? {
            guard (200 ..< 300).contains(response.statusCode) else {
                let message = String(data: data, encoding: .utf8)
                return NetworkError.apiError(statusCode: response.statusCode, message: message)
            }
            
            return nil
        }
        
        func finish(request: URLRequest, withError error: Error) {
            observer.didFailLoadingContent(for: request, withError: error)
            completion(.failure(error))
        }
        
        func finish(request: URLRequest, withValue value: Parser.Response, response: HTTPURLResponse, data: Data) {
            observer.didFinishLoadingContent(for: request, data: data, response: response)
            completion(.success(value))
        }
        
        do {
            let request = try requestBuilder.request(for: modifier.modify(endpoint: endpoint))
            observer.willSend(request: request)
            
            session.dataTask(with: request) { (data, response, error) in
                let networkResponse = NetworkResponse(data: data, response: response, error: error)
                
                switch networkResponse {
                case .error(let error):
                    finish(request: request, withError: error)
                case .content(let data, let response):
                    if let error = parseError(fromData: data, response: response) {
                        finish(request: request, withError: error)
                    }
                    else {
                        do {
                            let value = try endpoint.parser.parse(data: data)
                            finish(request: request, withValue: value, response: response, data: data)
                        }
                        catch {
                            finish(request: request, withError: error)
                        }
                    }
                }
            }.resume()
        }
        catch {
            completion(.failure(error))
        }
    }
    
    private enum NetworkResponse {
        case error(Error)
        case content(Data, HTTPURLResponse)
        
        init(data: Data?, response: URLResponse?, error: Error?) {
            if let error = error {
                self = .error(error)
            }
            else if let data = data, let response = response as? HTTPURLResponse {
                self = .content(data, response)
            }
            else {
                self = .error(NetworkError.badResponse)
            }
        }
    }
}

private class MergedNetworkClientObserver: NetoworkClientObserver {
    private let observers: [NetoworkClientObserver]
    
    public init(observers: [NetoworkClientObserver]) {
        self.observers = observers
    }
    
    public func willSend(request: URLRequest) {
        for observer in observers {
            observer.willSend(request: request)
        }
    }
    
    func didFinishLoadingContent(for request: URLRequest, data: Data, response: HTTPURLResponse) {
        for observer in observers {
            observer.didFinishLoadingContent(for: request, data: data, response: response)
        }
    }
    
    func didFailLoadingContent(for request: URLRequest, withError error: Error) {
        for observer in observers {
            observer.didFailLoadingContent(for: request, withError: error)
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
