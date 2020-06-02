//
//  MainViewController.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import Then

final class MainViewController: UITabBarController {
    private var searchViewController: SearchViewController = SearchViewController()
    private var favoriteViewController: FavoriteViewController = FavoriteViewController()
    
    private var searchTabBarItem: UITabBarItem = .init(
        title: "이미지 검색",
        image: UIImage(systemName: "photo"),
        selectedImage: UIImage(systemName: "photo.fill")
    )
    
    private var favoriteTabBarItem: UITabBarItem = .init(
        title: "즐겨찾기",
        image: UIImage(systemName: "suit.heart"),
        selectedImage: UIImage(systemName: "suit.heart.fill")
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
    }
    
    private func setAttributes() {
        view.backgroundColor = .white
        
        viewControllers = [
            UINavigationController(rootViewController: searchViewController),
            UINavigationController(rootViewController: favoriteViewController)
        ]
    
        searchViewController.do {
            $0.loadViewIfNeeded()
            $0.tabBarItem = searchTabBarItem
        }
        
        favoriteViewController.do {
            $0.loadViewIfNeeded()
            $0.tabBarItem = favoriteTabBarItem
        }
    }
}
