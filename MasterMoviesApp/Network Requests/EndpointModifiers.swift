//
//  EndpointModifiers.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct APIEndpointAuthenticator: EndpointModifier {
    public let apiKey: String
    
    public init(apiKey: String = "340528aae953e802b9f330ecb5aedbed") {
        self.apiKey = apiKey
    }
    
    public func modify<T>(endpoint: Endpoint<T>) -> Endpoint<T> {
        var params = endpoint.params
        params["api_key"] = apiKey
        return Endpoint(path: endpoint.path, method: endpoint.method, params: params, parser: endpoint.parser)
    }
}
