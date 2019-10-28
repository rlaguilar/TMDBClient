//
//  TMDBConfig.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct TMDBConfig: Codable {
    public let baseUrl: String
    public let backdropSizes: [String]
    public let posterSizes: [String]
    public let profileSizes: [String]
    
    private var backdropImageSizes: [ImageSize] { return self.backdropSizes.map(ImageSize.init(string:)) }
    private var posterImageSizes: [ImageSize] { return self.posterSizes.map(ImageSize.init(string:)) }
    private var profilesImageSizes: [ImageSize] { return self.profileSizes.map(ImageSize.init(string:)) }
    
    public func url(for name: String, imageType: ImageType) -> URL? {
        let sizes: [ImageSize]
        
        switch imageType {
        case .backdrop:
            sizes = backdropImageSizes
        case .poster:
            sizes = posterImageSizes
        case .profile:
            sizes = profilesImageSizes
        }
        
        return url(from: sizes, minWidth: imageType.minWidth, name: name)
    }
    
    private func url(from sizes: [ImageSize], minWidth: Int, name: String) -> URL? {
        guard let size = imageSize(from: sizes, minWidth: minWidth), let url = URL(string: baseUrl) else {
            return nil
        }
        
        return url.appendingPathComponent(size.identifier).appendingPathComponent(name)
    }
    
    private func imageSize(from sizes: [ImageSize], minWidth: Int) -> ImageSize? {
        return sizes.first(where: { $0.value >= minWidth })
    }
    
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "secureBaseUrl"
        case backdropSizes, posterSizes, profileSizes
    }
    
    public enum ImageType {
        case backdrop
        case poster
        case profile
        
        var minWidth: Int {
            switch self {
            case .backdrop: return 750
            case .poster: return 500
            case .profile: return 500
            }
        }
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
