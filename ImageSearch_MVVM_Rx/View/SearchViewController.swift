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
import Toaster

final class SearchViewController: BaseCollectionViewController {
    private let searchController: UISearchController = .init(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
    }
    
    func setAttributes() {
        title = "이미지 검색"
        navigationItem.searchController = searchController
        
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
        }
    }
    
    func bind(viewModel: SearchViewModel) {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(onNext: { text in
                Toast(text: text).show()
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true)
            })
            .bind(to: viewModel.searchBarText)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource[indexPath]
                viewModel.itemSelected.accept(item)
            })
            .disposed(by: disposeBag)
    }
}
