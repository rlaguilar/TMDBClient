//
//  APIResponseParser.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 25/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public protocol ResponseParser {
    associatedtype Response
    
    func parse(data: Data) throws -> Response
}

public struct APIReponseParser<Response: Decodable>: ResponseParser {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func parse(data: Data) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
