//
//  SectionTitleView.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
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
                .foregroundColor: ColorTheme.shared.primaryTextColor,
                .font: UIFont.systemFont(ofSize: 20),
                .kern: 1
            ]
        )
    }
}
