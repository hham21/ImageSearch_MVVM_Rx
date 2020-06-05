//
//  FavoriteViewModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxSwift
import RxCocoa

struct FavoriteViewModel {
    private var disposeBag: DisposeBag = .init()
    
    // MARK: - Output
    let dataSource: Driver<[ImageSection]>
    
    // MARK: - Input
    let itemSelected: PublishRelay<ImageCellData> = .init()
    
    init(model: FavoriteModel = .init()) {
        itemSelected
            .flatMap { model.delete(image: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        let dataSource = model.favorites()
            .map { [ImageSection(model: "이미지 섹션", items: model.makeCellData(from: $0))] }
            .asDriver(onErrorJustReturn: [])
        
        self.dataSource = dataSource
    }
}
