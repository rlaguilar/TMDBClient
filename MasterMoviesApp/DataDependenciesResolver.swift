//
//  DataDependenciesResolver.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct DataDependenciesResolver {
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    func resolveData(completion: @escaping (Result<DataDependencies, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        let configRequest = APIImageConfigRequest()
        var configResult: Result<APIImageConfig, Error>!
        
        dispatchGroup.enter()
        client.send(request: configRequest) { result in
            configResult = result
            dispatchGroup.leave()
        }
        
        let genresRequest = GenresRequest()
        var genresResult: Result<[Genre], Error>!
        
        dispatchGroup.enter()
        client.send(request: genresRequest) { result in
            genresResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            switch (configResult!, genresResult!) {
            case let (.success(config), .success(genres)):
                completion(.success(DataDependencies(genres: genres, imageConfig: config)))
            case let (.failure(error), _):
                completion(.failure(error))
            case let (_, .failure(error)):
                completion(.failure(error))
            }
        }
    }
}