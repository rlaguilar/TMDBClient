//
//  APIImageConfigEndpoint.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public extension Endpoint where Parser == ImageConfigParser {
    static func imageConfig() -> Endpoint {
        return Endpoint(path: "configuration", method: .get, params: [:], parser: ImageConfigParser())
    }
}

public struct ImageConfigParser: ResponseParser {
    private let configurationParser = APIReponseParser<Configuration>()
    
    public func parse(data: Data) throws -> APIImageConfig {
        return try configurationParser.parse(data: data).images
    }
    
    private struct Configuration: Codable {
        let images: APIImageConfig
    }
}
