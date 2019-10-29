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
    
    private let tagsContainer = UIStackView()
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
        reviewCounterView.style = .large
        
        contentView.addSubview(tagsContainer)
        tagsContainer.axis = .horizontal
        tagsContainer.spacing = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCounterView.translatesAutoresizingMaskIntoConstraints = false
        tagsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            
            tagsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            tagsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            reviewCounterView.bottomAnchor.constraint(equalTo: tagsContainer.topAnchor, constant: -20),
            reviewCounterView.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: reviewCounterView.topAnchor, constant: -14),
            titleLabel.leadingAnchor.constraint(equalTo: reviewCounterView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func update(movie: Movie, dependencies: Dependencies) {
        let gradientColor = dependencies.visual.colorTheme.backgroundColor
        gradientView.colors = [gradientColor.withAlphaComponent(0), gradientColor]
        
        let fontTheme = dependencies.visual.fontTheme
        titleLabel.attributedText = fontTheme.largeTitle(string: movie.title)
        reviewCounterView.count = ReviewCount(total: movie.voteCount, average: movie.voteAverage)
        reviewCounterView.onColor = dependencies.visual.colorTheme.accentColor
        reviewCounterView.offColor = dependencies.visual.colorTheme.offColor
        
        let arrangedSubviews = tagsContainer.arrangedSubviews
        
        for view in arrangedSubviews {
            tagsContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let tags = movie.genreIDs
        
        tags.compactMap { tagId in dependencies.data.genres.first(where: { $0.id == tagId })?.name }
            .map { tagView(forTag: $0, visual: dependencies.visual) }
            .forEach { tagView in
                tagsContainer.addArrangedSubview(tagView)
            }
        
        if let backdrop = movie.backdropPath {
            imageView.kf.setImage(with: dependencies.data.imageConfig.url(for: backdrop, imageType: .backdrop))
        }
        else if let poster = movie.posterPath {
            imageView.kf.setImage(with: dependencies.data.imageConfig.url(for: poster, imageType: .poster))
        }
        else {
            imageView.kf.setImage(with: Optional<Resource>.none)
        }
    }
    
    private func tagView(forTag tag: String, visual: VisualDependencies) -> UIView {
        let label = UILabel()
        label.attributedText = visual.fontTheme.small(string: tag)
        
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.5
        view.layer.borderColor = visual.colorTheme.borderColor.cgColor
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
}
