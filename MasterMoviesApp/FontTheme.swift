//
//  FontTheme.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 27/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public struct FontTheme {
    public let colorTheme: ColorTheme // TODO: Refactor this class so that it doesn't need the reference to the color theme
    public func largeTitle(string: String) -> NSAttributedString {
        return attributtedString(
            string: string,
            foregroundColor: colorTheme.secondaryTextColor,
            font: UIFont.systemFont(ofSize: 30),
            kern: 1.2,
            lineSpacing: 28
        )
    }
    
    public func title(string: String) -> NSAttributedString {
        return attributtedString(
            string: string,
            foregroundColor: colorTheme.primaryTextColor,
            font: UIFont.systemFont(ofSize: 20),
            kern: 1.2,
            lineSpacing: 28
        )
    }
    
    public func subtitle(string: String) -> NSAttributedString {
        return attributtedString(
            string: string,
            foregroundColor: colorTheme.primaryTextColor,
            font: UIFont.systemFont(ofSize: 16),
            kern: 1.2,
            lineSpacing: 28
        )
    }
    
    public func body(string: String) -> NSAttributedString {
        return attributtedString(
            string: string,
            foregroundColor: colorTheme.secondaryTextColor,
            font: UIFont.systemFont(ofSize: 14),
            kern: 1,
            lineSpacing: 0
        )
    }
    
    public func small(string: String) -> NSAttributedString {
        return attributtedString(
            string: string,
            foregroundColor: colorTheme.secondaryTextColor,
            font: UIFont.systemFont(ofSize: 10),
            kern: 1,
            lineSpacing: 0
        )
    }
    
    private func attributtedString(string: String, foregroundColor: UIColor, font: UIFont, kern: Float, lineSpacing: CGFloat = 0) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        return NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: foregroundColor,
                .font: font,
                .kern: kern
            ]
        )
    }
}
