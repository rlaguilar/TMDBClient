//
//  DiscoverMoviesDataSource.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public class MoviesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    public var featuredContents: [FeaturedContent] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            collectionView?.delegate = self
            
            collectionView?.register(HeroMovieCell.self, forCellWithReuseIdentifier: "hero")
            collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "movie")
            collectionView?.register(SectionTitleView.self, forSupplementaryViewOfKind: "section-title", withReuseIdentifier: "section-title")
            collectionView?.register(SectionActionView.self, forSupplementaryViewOfKind: "section-action", withReuseIdentifier: "section-action")
        }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero", for: indexPath) as! HeroMovieCell
            cell.movie = movie
            return cell
        case .section(_, let movies):
            let movie = movies[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie", for: indexPath) as! MovieCell
            cell.movie = movie
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard case let .section(title, _) = featuredContents[indexPath.section] else {
            fatalError()
        }
        
        if kind == "section-title" {
            let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! SectionTitleView
            sectionTitleView.title = title
            return sectionTitleView
        }
        else {
            let sectionActionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! SectionActionView
            return sectionActionView
        }
    }
}
