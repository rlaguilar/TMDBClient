//
//  APIImageConfigRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct APIImageConfigRequest: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init() {
        path = "configuration"
        method = .get
        params = [:]
    }
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> APIImageConfig {
        return try decoder.decode(Wrapper.self, from: data).images
    }
    
    private struct Wrapper: Codable {
        let images: APIImageConfig
    }
}
