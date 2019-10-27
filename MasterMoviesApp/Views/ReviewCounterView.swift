//
//  ReviewCounterView.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public struct ReviewCount {
    public let total: Int
    public let average: Float
    
    fileprivate var starsCount: Int {
        return Int((average / 2).rounded())
    }
    
    fileprivate var text: String {
        switch total {
        case 0:
            return "No Reviews"
        case 1:
            return "1 Review"
        default:
            return "\(total) Reviews"
        }
    }
    
    static let zero = ReviewCount(total: 0, average: 0)
}

public class ReviewCounterView: UIView {
    private let starsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let label = UILabel()
    
    public var style: Style = .small {
        didSet {
            updateLabelText()
            resizeStarViews()
        }
    }
    
    public var count: ReviewCount = .zero {
        didSet {
            updateLabelText()
            let stars = count.starsCount
            
            for (index, view) in starsContainer.arrangedSubviews.enumerated() {
                if index < stars {
                    view.tintColor = ColorTheme.shared.accentColor
                }
                else {
                    view.tintColor = ColorTheme.shared.offColor
                }
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let starViews = (0 ..< 5).map { _ -> UIImageView in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintAdjustmentMode = .normal
            imageView.tintColor = ColorTheme.shared.offColor
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
            ])
            
            return imageView
        }
        
        for view in starViews {
            starsContainer.addArrangedSubview(view)
        }
        
        addSubview(starsContainer)
        addSubview(label)
        
        starsContainer.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: starsContainer.trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        resizeStarViews()
    }
    
    private func updateLabelText() {
        label.attributedText = style.formattedReviewText(string: count.text)
    }
    
    private var starWidthConstraint: NSLayoutConstraint?
    
    private func resizeStarViews() {
        let firstStar = starsContainer.arrangedSubviews[0]
        
        starWidthConstraint?.isActive = false
        starWidthConstraint = firstStar.widthAnchor.constraint(equalToConstant: style.starWidth)
        starWidthConstraint?.isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public enum Style {
        case small
        case large
        
        fileprivate func formattedReviewText(string: String) -> NSAttributedString {
            switch self {
            case .small:
                return FontTheme.shared.small(string: string)
            case .large:
                return FontTheme.shared.body(string: string)
            }
        }
        
        fileprivate var starWidth: CGFloat {
            switch self {
            case .small:
                return 9
            case .large:
                return 12
            }
        }
    }
}
