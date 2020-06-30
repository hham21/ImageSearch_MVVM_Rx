//
//  FavoriteViewController.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift

final class FavoriteViewController: BaseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
    }
    
    private func setAttributes() {
        title = "즐겨찾기"
    }
        
    func bind(viewModel: FavoriteViewModel) {
        viewModel.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .throttle(.milliseconds(400), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource[indexPath]
                viewModel.itemSelected.accept(item)
            })
            .disposed(by: disposeBag)
    }
}
