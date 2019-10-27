//
//  ColorTheme.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public struct ColorTheme {
    public static let shared = ColorTheme()
    
    public let accentColor: UIColor = UIColor(r: 251, g: 77, b: 92)
    public var backgroundColor = UIColor(r: 29, g: 28, b: 39)
    public let primaryTextColor: UIColor = .white
    public let secondaryTextColor = UIColor(r: 202, g: 203, b: 216)
    public let borderColor: UIColor = .lightGray
    public let offColor = UIColor(r: 78, g: 75, b: 97)
    public let scrollIndicatorStyle = UIScrollView.IndicatorStyle.white
}

private extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
