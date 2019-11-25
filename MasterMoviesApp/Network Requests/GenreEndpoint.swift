//
//  GenreEndpoint.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public extension Endpoint where Parser == MovieGenresParser {
    static func movieGenres() -> Endpoint {
        return Endpoint(path: "genre/movie/list", method: .get, params: [:], parser: MovieGenresParser())
    }
}

public struct MovieGenresParser: ResponseParser {
    private let genreParser = APIReponseParser<GenreList>()
    
    public func parse(data: Data) throws -> [Genre] {
        return try genreParser.parse(data: data).genres
    }
    
    private struct GenreList: Codable {
        let genres: [Genre]
    }
}
