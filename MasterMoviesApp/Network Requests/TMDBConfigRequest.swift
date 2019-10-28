//
//  TMDBConfigRequest.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct APIData {
    public static var shared = APIData(
        genres: [],
        config: TMDBConfig(
            baseUrl: "https://image.tmdb.org/t/p/",
            backdropSizes: ["original"],
            posterSizes: ["original"],
            profileSizes: ["original"]
        )
    )
    
    public let genres: [Genre]
    public let config: TMDBConfig
}

public struct APIDataRetriever {
    private let networkRequester: NetworkRequester
    
    public init(networkRequester: NetworkRequester) {
        self.networkRequester = networkRequester
    }
    
    func retrieveData(completion: @escaping (Result<APIData, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        let configRequest = TMDBConfigRequest()
        var configResult: Result<TMDBConfig, Error>!
        
        dispatchGroup.enter()
        networkRequester.send(request: configRequest) { result in
            configResult = result
            dispatchGroup.leave()
        }
        
        let genresRequest = GenresRequest()
        var genresResult: Result<[Genre], Error>!
        
        dispatchGroup.enter()
        networkRequester.send(request: genresRequest) { result in
            genresResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            switch (configResult!, genresResult!) {
            case let (.success(config), .success(genres)):
                completion(.success(APIData(genres: genres, config: config)))
            case let (.failure(error), _):
                completion(.failure(error))
            case let (_, .failure(error)):
                completion(.failure(error))
            }
        }
    }
}

public struct TMDBConfigRequest: APIRequest {
    public let path: String
    
    public let method: HTTPMethod
    
    public let params: [String : Any]
    
    public init() {
        path = "configuration"
        method = .get
        params = [:]
    }
    
    public func parse(data: Data, decoder: JSONDecoder) throws -> TMDBConfig {
        return try decoder.decode(Wrapper.self, from: data).images
    }
    
    private struct Wrapper: Codable {
        let images: TMDBConfig
    }
}
