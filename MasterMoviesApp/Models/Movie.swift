//
//  Movie.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct Movie: Codable {
    public let title: String
}

public extension Movie {
    static let murder = Movie(title: "Murder On The Orient Express")
    static let starWars = Movie(title: "Rogue One: A Stars War Story")
    static let terminator = Movie(title: "Terminator: Dark Fate")
    static let godfather = Movie(title: "The Godfather")
    static let mile = Movie(title: "The Green Mile")
    
    static func generateCategory() -> [Movie] {
        var movies: [Movie] = [.starWars, .terminator, .godfather, .mile]
        var randomCategory: [Movie] = []
        
        while let movie = movies.randomElement() {
            randomCategory.append(movie)
            movies.removeAll(where: { $0.title == movie.title })
        }
        
        return randomCategory
    }
}
