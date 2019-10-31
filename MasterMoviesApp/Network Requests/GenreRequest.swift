//
//  GenreRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct GenresRequest: APIRequest {
    public let path = "genre/movie/list"
    public let method: HTTPMethod = .get
    public let params: [String : Any] = [:]
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> [Genre] {
        return try decoder.decode(GenreList.self, from: data).genres
    }
    
    private struct GenreList: Codable {
        let genres: [Genre]
    }
}
