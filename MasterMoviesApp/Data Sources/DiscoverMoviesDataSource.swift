//
//  DiscoverMoviesDataSource.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public class MoviesDataSource: NSObject, UICollectionViewDataSource {
    private let sectionTitleIdentifier = "section-title"
    private let sectionActionIdentifier = "section-action"
    private let heroMovieIdentifier = "hero-movie"
    private let standardMovieIdentifier = "standard-movie"
    
    public var featuredContents: [FeaturedContent] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    public weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            
            collectionView?.register(HeroMovieCell.self, forCellWithReuseIdentifier: heroMovieIdentifier)
            collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: standardMovieIdentifier)
            collectionView?.register(
                SectionTitleView.self,
                forSupplementaryViewOfKind: FeatureContentLayout.sectionTitleElementKind,
                withReuseIdentifier: sectionTitleIdentifier
            )
            collectionView?.register(
                SectionActionView.self,
                forSupplementaryViewOfKind: FeatureContentLayout.sectionActionElementKind,
                withReuseIdentifier: sectionActionIdentifier
            )
        }
    }
    
    private let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return featuredContents.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch featuredContents[section] {
        case .section(_, let movies):
            return movies.count
        case .single:
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch featuredContents[indexPath.section] {
        case .single(let movie):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heroMovieIdentifier, for: indexPath) as! HeroMovieCell
            cell.update(movie: movie, dependencies: dependencies)
            return cell
        case .section(_, let movies):
            let movie = movies[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: standardMovieIdentifier, for: indexPath) as! MovieCell
            cell.update(movie: movie, dependencies: dependencies)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard case let .section(title, _) = featuredContents[indexPath.section] else {
            fatalError()
        }
        
        if kind == FeatureContentLayout.sectionTitleElementKind {
            let sectionTitleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: sectionTitleIdentifier,
                for: indexPath
                ) as! SectionTitleView
            
            sectionTitleView.update(title: title, visual: dependencies.visual)
            return sectionTitleView
        }
        else {
            let sectionActionView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: sectionActionIdentifier,
                for: indexPath
                ) as! SectionActionView
            
            sectionActionView.update(visual: dependencies.visual)
            return sectionActionView
        }
    }
}
