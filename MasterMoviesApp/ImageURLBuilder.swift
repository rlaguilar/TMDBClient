//
//  ImageURLBuilder.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 4/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public class ImageURLBuilder {
    public struct SizeConfig {
        public let posterMinWidth: Int
        public let backdropMinWidth: Int
        public let profileMinWidth: Int
        
        public static let `default` = SizeConfig(posterMinWidth: 500, backdropMinWidth: 750, profileMinWidth: 500)
    }
    
    private let posterURLBuilder: _URLBuilder
    private let backdropURLBuilder: _URLBuilder
    private let profileURLBuilder: _URLBuilder
    
    private let sizeConfig: SizeConfig
    
    init?(usingAPIConfig apiConfig: APIImageConfig, sizeConfig: SizeConfig = .default) {
        guard let baseURL = URL(string: apiConfig.baseUrl) else {
            return nil
        }
        
        posterURLBuilder = _URLBuilder(baseURL: baseURL, availableApiSizes: apiConfig.posterSizes)
        backdropURLBuilder = _URLBuilder(baseURL: baseURL, availableApiSizes: apiConfig.backdropSizes)
        profileURLBuilder = _URLBuilder(baseURL: baseURL, availableApiSizes: apiConfig.profileSizes)
        self.sizeConfig = sizeConfig
    }
    
    public func url(forPosterPath path: String) -> URL? {
        return posterURLBuilder.url(forPath: path, minWidth: sizeConfig.posterMinWidth)
    }
    
    public func url(forBackdropPath path: String) -> URL? {
        return backdropURLBuilder.url(forPath: path, minWidth: sizeConfig.backdropMinWidth)
    }
    
    public func url(forProfilePath path: String) -> URL? {
        return profileURLBuilder.url(forPath: path, minWidth: sizeConfig.profileMinWidth)
    }
}

private class _URLBuilder {
    private let baseURL: URL
    private let availableImageSizes: [ImageSize]
    
    init(baseURL: URL, availableApiSizes sizes: [String]) {
        self.baseURL = baseURL
        availableImageSizes = sizes.map { ImageSize(string: $0) }
    }
    
    public func url(forPath path: String, minWidth: Int) -> URL? {
        guard let size = availableImageSizes.first(where: { $0.value >= minWidth }) else {
            return nil
        }
        
        return baseURL.appendingPathComponent(size.identifier).appendingPathComponent(path)
    }
    
    private struct ImageSize {
        let identifier: String
        let value: Int
        
        init(string: String) {
            identifier = string
            
            if string == "original" {
                value = Int.max
            }
            else {
                let suffix = string.suffix(string.count - 1)
                
                guard let value = Int(suffix) else {
                    self.value = Int.min
                    return
                }
                
                self.value = value
            }
        }
    }
}
