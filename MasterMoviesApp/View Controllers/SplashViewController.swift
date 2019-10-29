//
//  SplashViewController.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 28/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import UIKit

public class SplahViewController: UIViewController {
    private let colorTheme: ColorTheme
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "MOV-e"
        label.font = UIFont.systemFont(ofSize: 56, weight: .black)
        label.textColor = colorTheme.accentColor
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tmdb-logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public init(colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(appNameLabel)
        view.addSubview(logoImageView)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            logoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            appNameLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
