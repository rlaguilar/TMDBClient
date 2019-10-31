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
    private let dataSource: MoviesDataSource
    private let featuredContent: [FeaturedContent]
    private let dependencies: Dependencies
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public init(featuredContent: [FeaturedContent], dependencies: Dependencies) {
        self.featuredContent = featuredContent
        self.dependencies = dependencies
        self.dataSource = MoviesDataSource(dependencies: dependencies)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTheme = dependencies.visual.colorTheme
        view.backgroundColor = colorTheme.backgroundColor
        collectionView.backgroundColor = .clear
        collectionView.indicatorStyle = colorTheme.scrollIndicatorStyle
        view.addSubview(collectionView)
        dataSource.collectionView = collectionView
        collectionView.contentInsetAdjustmentBehavior = .never
        self.dataSource.featuredContents = featuredContent
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

public struct FeatureContentLayout {
    public static let sectionTitleElementKind  = "section-title-kind"
    public static let sectionActionElementKind  = "section-action-kind"
}

fileprivate extension FeaturedContent {
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .section:
            return NSCollectionLayoutSize(widthDimension: .absolute(232), heightDimension: .absolute(390))
        case .single:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.237333))
        }
    }
    
    var orthogonalScrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .section:
            return .continuousGroupLeadingBoundary
        case .single: return .none
        }
    }
    
    var sectionInsets: NSDirectionalEdgeInsets {
        switch self {
        case .section:
            return NSDirectionalEdgeInsets(top: 25, leading: 16, bottom: 40, trailing: 16)
        case .single: return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 26, trailing: 0)
        }
    }
    
    var sectionHeaders: [NSCollectionLayoutBoundarySupplementaryItem] {
        switch self {
        case .section:
            let sectionTitle = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .estimated(24)
                ),
                elementKind: FeatureContentLayout.sectionTitleElementKind,
                alignment: .topLeading
            )
            
            let seeAllAction = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3),
                    heightDimension: .estimated(24)
                ),
                elementKind: FeatureContentLayout.sectionActionElementKind,
                alignment: .topTrailing
            )
            
            return [sectionTitle, seeAllAction]
        case .single: return []
        }
    }
}
