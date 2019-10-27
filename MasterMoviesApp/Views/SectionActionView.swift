//
//  SectionActionView.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

class SectionActionView: UICollectionReusableView {
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        button.setAttributedTitle(FontTheme.shared.small(string: "SEE ALL"), for: .normal)
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
}
