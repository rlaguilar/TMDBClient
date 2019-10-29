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
    public let posterPath: String?
    public let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, voteCount, genreIDs = "genreIds", voteAverage, posterPath, backdropPath
    }
}
