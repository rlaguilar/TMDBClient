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
    private let reviewsLabel = UILabel()
    private let imageView = UIImageView()
    
    var movie: Movie? {
        didSet {
            titleLabel.attributedText = formatted(title: movie?.title ?? "")
            reviewsLabel.attributedText = formatted(reviews: "⭐️⭐️⭐️⭐️⭐️ 295 Reviews")
            imageView.kf.setImage(with: movie?.posterURL)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        addSubview(titleLabel)
        addSubview(reviewsLabel)
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
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
