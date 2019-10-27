//
//  MoviesViewController.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit
import Kingfisher

public class MoviesViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    private let dataSource = MoviesDataSource()
    private let moviesDiscoverer: MoviesDiscoverer
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public init(moviesDiscoverer: MoviesDiscoverer) {
        self.moviesDiscoverer = moviesDiscoverer
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorTheme.shared.backgroundColor
        collectionView.backgroundColor = .clear
        collectionView.indicatorStyle = ColorTheme.shared.scrollIndicatorStyle
        view.addSubview(collectionView)
        dataSource.collectionView = collectionView
        collectionView.contentInsetAdjustmentBehavior = .never
        
        moviesDiscoverer.discoverMovies(forDate: Date()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let content):
                    self.dataSource.featuredContents = content
                case .failure(let error):
                    print("Unable to discover movies with error: \(error)")
                }
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [dataSource] (index, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = dataSource.featuredContents[index].groupSize
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = dataSource.featuredContents[index].sectionInsets
            section.orthogonalScrollingBehavior = dataSource.featuredContents[index].orthogonalScrollingBehaviour
            section.boundarySupplementaryItems = dataSource.featuredContents[index].sectionHeaders
            return section
        }
        
        return layout
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension FeaturedContent {
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .multiple:
            return NSCollectionLayoutSize(widthDimension: .absolute(232), heightDimension: .absolute(390))
        case .single:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.237333))
        }
    }
    
    var orthogonalScrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .multiple:
            return .continuousGroupLeadingBoundary
        case .single: return .none
        }
    }
    
    var sectionInsets: NSDirectionalEdgeInsets {
        switch self {
        case .multiple:
            return NSDirectionalEdgeInsets(top: 25, leading: 16, bottom: 40, trailing: 16)
        case .single: return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 26, trailing: 0)
        }
    }
    
    var sectionHeaders: [NSCollectionLayoutBoundarySupplementaryItem] {
        switch self {
        case .multiple:
            let sectionTitle = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .estimated(24)
                ),
                elementKind: "section-title",
                alignment: .topLeading
            )
            
            let seeAllAction = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3),
                    heightDimension: .estimated(24)
                ),
                elementKind: "section-action",
                alignment: .topTrailing
            )
            
            return [sectionTitle, seeAllAction]
        case .single: return []
        }
    }
}
