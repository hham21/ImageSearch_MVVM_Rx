//
//  FavoriteViewModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias WillDisplayCell = (cell: UICollectionViewCell, at: IndexPath)

struct SearchViewModel {
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Output
    let dataSource: Driver<[ImageCellData]>
    let errorMessage: Signal<String>
    
    // MARK: - Input
    let searchBarText: PublishRelay<String> = .init()
    let willDisplayCell: PublishRelay<WillDisplayCell> = .init()
    let itemSelected: PublishRelay<ImageCellData> = .init()
    
    init() {
        
    }
}
