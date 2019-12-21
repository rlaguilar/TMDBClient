//
//  FontTheme.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public struct TextStyle {
    public let font: UIFont
    public let kern: Float
    public let lineSpacing: CGFloat
    
    public static let `default` = TextStyle(font: UIFont.systemFont(ofSize: 12), kern: 1, lineSpacing: 0)
}

public struct FontTheme {
    public let largeTitle: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 30), kern: 1.2, lineSpacing: 28)
    public let title: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 20), kern: 1.2, lineSpacing: 28)
    public let subtitle: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 16), kern: 1.2, lineSpacing: 28)
    public let body: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 14), kern: 1, lineSpacing: 0)
    public let small: TextStyle = TextStyle(font: UIFont.systemFont(ofSize: 10), kern: 1, lineSpacing: 0)
}
