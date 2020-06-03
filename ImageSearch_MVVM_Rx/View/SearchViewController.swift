//
//  SearchViewController.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<ImageSection>

final class SearchViewController: UIViewController {
    private var disposeBag: DisposeBag = .init()
    
    private let searchController: UISearchController = .init(searchResultsController: nil)
    private let flowLayout: UICollectionViewFlowLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: flowLayout)
//    private lazy var dataSource: DataSource =
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setAttribute() {
        title = "이미지 검색"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        
    }
}
