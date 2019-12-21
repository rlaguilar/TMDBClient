//
//  NSAttributtedString+.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 21/12/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    convenience init(string: String, style: TextStyle, foregroundColor: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        
        self.init(
            string: string,
            attributes: [
                .foregroundColor: foregroundColor,
                .font: style.font,
                .kern: style.kern
            ]
        )
    }
}
