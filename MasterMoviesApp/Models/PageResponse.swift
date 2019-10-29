//
//  PageResponse.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct PageResponse<T: Codable>: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [T]
}
