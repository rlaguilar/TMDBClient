//
//  Dependencies.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation

public struct Dependencies {
    let visual: VisualDependencies
    let data: DataDependencies
}

public struct VisualDependencies {
    public let colorTheme: ColorTheme
    public let fontTheme: FontTheme
}

public struct DataDependencies {
    public let genres: [Genre]
    public let imageURLBuilder: ImageURLBuilder
}
