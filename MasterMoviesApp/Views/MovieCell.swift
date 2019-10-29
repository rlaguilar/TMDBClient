//
//  MovieCell.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

import Kingfisher

public class MovieCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let reviewCounterView = ReviewCounterView()
    private let imageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(titleLabel)
        contentView.addSubview(reviewCounterView)
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCounterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 340),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            
            reviewCounterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewCounterView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
        ])
    }
    
    public func update(movie: Movie, dependencies: Dependencies) {
        let visual = dependencies.visual
        titleLabel.attributedText = visual.fontTheme.subtitle(string: movie.title)
        reviewCounterView.onColor = visual.colorTheme.accentColor
        reviewCounterView.offColor = visual.colorTheme.offColor
        reviewCounterView.count = ReviewCount(total: movie.voteCount, average: movie.voteAverage)

        if let poster = movie.posterPath {
            imageView.kf.setImage(with: dependencies.data.imageConfig.url(for: poster, imageType: .poster))
        }
        else if let backdrop = movie.backdropPath {
            imageView.kf.setImage(with: dependencies.data.imageConfig.url(for: backdrop, imageType: .backdrop))
        }
        
        else {
            imageView.kf.setImage(with: Optional<Resource>.none)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
