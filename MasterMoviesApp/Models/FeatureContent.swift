//
//  FeatureContent.swift
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
