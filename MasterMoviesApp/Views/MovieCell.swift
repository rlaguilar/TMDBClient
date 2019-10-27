//
//  MovieCell.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let reviewCounterView = ReviewCounterView()
    private let imageView = UIImageView()
    
    var movie: Movie? {
        didSet {
            let fontTheme = FontTheme.shared
            titleLabel.attributedText = fontTheme.subtitle(string: movie?.title ?? "")
            reviewCounterView.count = ReviewCount(total: movie?.voteCount ?? 0, average: movie?.voteAverage ?? 0)
            imageView.kf.setImage(with: movie?.posterURL)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
