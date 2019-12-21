//
//  HeroMovieCell.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

import Kingfisher

/*
 TODO:
 - Add play button
*/

class HeroMovieCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let gradientView = GradientView()
    
    private let genresContainer = UIStackView()
    private let reviewCounterView = ReviewCounterView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(reviewCounterView)
        
        contentView.addSubview(genresContainer)
        genresContainer.axis = .horizontal
        genresContainer.spacing = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCounterView.translatesAutoresizingMaskIntoConstraints = false
        genresContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            
            genresContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            genresContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genresContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            reviewCounterView.bottomAnchor.constraint(equalTo: genresContainer.topAnchor, constant: -20),
            reviewCounterView.leadingAnchor.constraint(equalTo: genresContainer.leadingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: reviewCounterView.topAnchor, constant: -14),
            titleLabel.leadingAnchor.constraint(equalTo: reviewCounterView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func update(movie: Movie, dependencies: Dependencies) {
        let gradientColor = dependencies.visual.colorTheme.backgroundColor
        gradientView.colors = [gradientColor.withAlphaComponent(0), gradientColor]
        
        let visual = dependencies.visual
        titleLabel.attributedText = NSAttributedString(
            string: movie.title,
            style: visual.fontTheme.largeTitle,
            foregroundColor: visual.colorTheme.secondaryTextColor
        )
        reviewCounterView.count = ReviewCount(total: movie.voteCount, average: movie.voteAverage)
        reviewCounterView.style = ReviewCounterView.Style(
            textStyle: visual.fontTheme.body,
            titleColor: visual.colorTheme.secondaryTextColor,
            onColor: visual.colorTheme.accentColor,
            offColor: visual.colorTheme.offColor,
            size: .large
        )
        
        let arrangedSubviews = genresContainer.arrangedSubviews
        
        for view in arrangedSubviews {
            genresContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        movie.genreIDs.compactMap { genreId in dependencies.data.genres.first(where: { $0.id == genreId })?.name }
            .map { GenreView(genre: $0, visual: dependencies.visual) }
            .forEach { genreView in
                genresContainer.addArrangedSubview(genreView)
            }
        
        if let backdrop = movie.backdropPath {
            imageView.kf.setImage(with: dependencies.data.imageURLBuilder.url(forBackdropPath: backdrop))
        }
        else if let poster = movie.posterPath {
            imageView.kf.setImage(with: dependencies.data.imageURLBuilder.url(forPosterPath: poster))
        }
        else {
            imageView.kf.setImage(with: Optional<Resource>.none)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class GradientView: UIView {
        override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        
        var colors: [UIColor] = [] {
            didSet {
                let gradientLayer = layer as! CAGradientLayer
                gradientLayer.colors = colors.map { $0.cgColor }
            }
        }
    }
    
    private class GenreView: UIView {
        private let label = UILabel()
        
        init(genre: String, visual: VisualDependencies) {
            super.init(frame: .zero)
            
            label.attributedText = NSAttributedString(
                string: genre,
                style: visual.fontTheme.small,
                foregroundColor: visual.colorTheme.secondaryTextColor
                )
            
            backgroundColor = .clear
            layer.borderWidth = 0.5
            layer.borderColor = visual.colorTheme.borderColor.cgColor
            layer.cornerRadius = 4
            addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
                label.heightAnchor.constraint(equalTo: heightAnchor, constant: -10)
            ])
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
