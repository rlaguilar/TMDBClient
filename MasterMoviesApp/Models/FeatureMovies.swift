//
//  FeatureMovies.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public enum FeaturedContent {
    case single(Movie)
    case multiple(name: String, movies: [Movie])
}

public extension FeaturedContent {
    static let testData: [FeaturedContent] = [
        .single(Movie(title: "Murder On The Orient Express")),
        .multiple(name: "Movies On Theater", movies: Movie.generateCategory()),
        .multiple(name: "Comming Soon", movies: Movie.generateCategory()),
        .multiple(name: "Popular Movies", movies: Movie.generateCategory())
    ]
}
