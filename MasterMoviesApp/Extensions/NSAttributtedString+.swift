//
//  NSAttributtedString+.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 21/12/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    convenience init(string: String, style: TextStyle, foregroundColor color: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = style.lineSpacing
        
        let attrs: [NSAttributedString.Key : Any] = [
            .foregroundColor: color,
            .font: style.font,
            .kern: style.kern,
            .paragraphStyle: paragraphStyle
        ]
        
        self.init(string: string, attributes: attrs)
    }
}
