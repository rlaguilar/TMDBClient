//
//  GenreRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct GenresRequest: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init() {
        path = "genre/movie/list"
        method = .get
        params = [:]
    }
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> [Genre] {
        return try decoder.decode(GenreList.self, from: data).genres
    }
}

private struct GenreList: Codable {
    let genres: [Genre]
}
