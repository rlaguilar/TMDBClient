//
//  NetworkTypes.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct Endpoint<Parser: ResponseParser> {
    let path: String
    let method: HTTPMethod
    let params: [String: Any]
    let parser: Parser
}

public enum HTTPMethod {
    case get
    case post([String: Any])
    
    var text: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public enum NetworkError: Error, Equatable {
    case badRequest
    case badResponse
    case apiError(statusCode: Int, message: String?)
}
