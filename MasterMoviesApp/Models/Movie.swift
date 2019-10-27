//
//  Movie.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct Movie: Codable {
    public let id: Int
    public let title: String
    public let voteCount: Int
    public let voteAverage: Float
    public let genreIDs: [Int]
    public let posterPath: String
    public let backdropPath: String?
    
    var posterURL: URL? {
        // TODO: Retrieve images configurations in the right way
        return URL(string: "https://image.tmdb.org/t/p/w780/")?.appendingPathComponent(posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        
        return URL(string: "https://image.tmdb.org/t/p/w780/")?.appendingPathComponent(backdropPath)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
