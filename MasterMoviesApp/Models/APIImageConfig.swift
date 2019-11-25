//
//  APIImageConfig.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct APIImageConfig: Codable {
    public let baseUrl: String
    public let backdropSizes: [String]
    public let posterSizes: [String]
    public let profileSizes: [String]
    
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "secureBaseUrl"
        case backdropSizes, posterSizes, profileSizes
    }
}
