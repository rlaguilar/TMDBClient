//
//  MoviesViewController.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 26/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    private let dataSource = MoviesDataSource()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(r: 29, g: 28, b: 39)
        collectionView.indicatorStyle = .white
        view.addSubview(collectionView)
        dataSource.collectionView = collectionView
        dataSource.featuredContents = FeaturedContent.testData
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLayoutSubviews() {
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
}

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
        case .multiple(_, let movies):
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
        case .multiple(_, let movies):
            let movie = movies[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie", for: indexPath) as! MovieCell
            cell.movie = movie
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard case let .multiple(title, _) = featuredContents[indexPath.section] else {
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

private class SectionTitleView: UICollectionReusableView {
    private let label = UILabel()
    
    var title: String? {
        didSet {
            label.attributedText = formatted(title: title ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    private func formatted(title: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 20),
                .kern: 1
            ]
        )
    }
}

private class SectionActionView: UICollectionReusableView {
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        button.setAttributedTitle(formatted(action: "SEE ALL"), for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.sizeToFit()
        button.center = CGPoint(x: bounds.width - button.bounds.width / 2, y: button.bounds.midY)
    }
    
    private func formatted(action: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: action,
            attributes: [
                .foregroundColor: UIColor(r: 202, g: 203, b: 216),
                .font: UIFont.boldSystemFont(ofSize: 10),
                .kern: 1
            ]
        )
    }
}

/*
 TODO:
 - Use image view
 - Add gradient
 - Add play button
*/
private class HeroMovieCell: UICollectionViewCell {
    private let tagsContainer = UIStackView()
    private let reviewsLabel = UILabel()
    private let titleLabel = UILabel()
    
    fileprivate var movie: Movie? {
        didSet {
            titleLabel.attributedText = formatted(title: movie?.title ?? "")
            reviewsLabel.attributedText = formatted(reviews: "⭐️⭐️⭐️⭐️⭐️ 295 Reviews")
            
            let arrangedSubviews = tagsContainer.arrangedSubviews
            
            for view in arrangedSubviews {
                tagsContainer.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            ["THRILLER", "ACTION"].map { tagView(forTag: $0) }.forEach { tagView in
                tagsContainer.addArrangedSubview(tagView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 19, g: 18, b: 29)
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(reviewsLabel)
        contentView.addSubview(tagsContainer)
        tagsContainer.axis = .horizontal
        tagsContainer.spacing = 8
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tagsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            tagsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            reviewsLabel.bottomAnchor.constraint(equalTo: tagsContainer.topAnchor, constant: -20),
            reviewsLabel.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: reviewsLabel.topAnchor, constant: -14),
            titleLabel.leadingAnchor.constraint(equalTo: reviewsLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func tagView(forTag tag: String) -> UIView {
        let label = UILabel()
        label.attributedText = formatted(tag: tag)
        
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 4
        view.addSubview(label)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16),
            label.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return view
    }
    
    private func formatted(title: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor(r: 202, g: 203, b: 216),
                .font: UIFont.systemFont(ofSize: 30),
                .kern: 0
            ]
        )
    }
    
    private func formatted(reviews: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: reviews,
            attributes: [
                .foregroundColor: UIColor(r: 202, g: 203, b: 216),
                .font: UIFont.systemFont(ofSize: 14),
                .kern: 1
            ]
        )
    }
    
    private func formatted(tag: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: tag,
            attributes: [
                .foregroundColor: UIColor(r: 202, g: 203, b: 216),
                .font: UIFont.systemFont(ofSize: 9),
                .kern: 1
            ]
        )
    }
}

private class MovieCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let reviewsLabel = UILabel()
    private let imageView = UIImageView()
    
    fileprivate var movie: Movie? {
        didSet {
            titleLabel.attributedText = formatted(title: movie?.title ?? "")
            reviewsLabel.attributedText = formatted(reviews: "⭐️⭐️⭐️⭐️⭐️ 295 Reviews")
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.backgroundColor = .lightGray
        addSubview(titleLabel)
        addSubview(reviewsLabel)
        
        imageView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 232, height: 340)
        let size = titleLabel.sizeThatFits(CGSize(width: bounds.width, height: .infinity))
        titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: imageView.frame.maxY + 12), size: CGSize(width: min(size.width, bounds.width), height: size.height))
        reviewsLabel.sizeToFit()
        reviewsLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 6, width: reviewsLabel.bounds.width, height: reviewsLabel.bounds.height)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func formatted(title: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 16),
                .kern: 1.2
            ]
        )
    }
    
    private func formatted(reviews: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 28
        
        return NSAttributedString(
            string: reviews,
            attributes: [
                .foregroundColor: UIColor(r: 202, g: 203, b: 216),
                .font: UIFont.systemFont(ofSize: 10),
                .kern: 1
            ]
        )
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

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
