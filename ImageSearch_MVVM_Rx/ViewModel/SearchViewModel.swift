//
//  SearchViewModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources

typealias WillDisplayCell = (cell: UICollectionViewCell, at: IndexPath)
typealias ImageSection = AnimatableSectionModel<String, ImageCellData>

struct SearchViewModel {
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Output
    let dataSource: Driver<[ImageSection]>
    let errorMessage: Signal<String>
    
    // MARK: - Input
    let searchBarText: PublishRelay<String> = .init()
    let willDisplayCell: PublishRelay<WillDisplayCell> = .init()
    let itemSelected: PublishRelay<ImageCellData> = .init()
    
    // MARK: - Properties
    private var imageData: PublishRelay<[Image]> = .init()
    private var lastQuery: PublishRelay<Query> = .init()
    
    init(model: SearchModel = SearchModel()) {
        let newSearch = searchBarText
            .map { Query(text: $0, page: 1)}
        
        let searchResult = newSearch
            .flatMapLatest { model.getImages(from: $0) }
            .share()
        
        let searchResponse = searchResult
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else { return nil }
                return response
            }
            .filterNil()
        
        let newImages = searchResponse
            .map { $0.documents }
        
        Observable.merge(newSearch)
            .bind(to: lastQuery)
            .disposed(by: disposeBag)
        
        Observable.merge(newImages)
            .bind(to: imageData)
            .disposed(by: disposeBag)
        
        let dataSource = imageData
            .map { [ImageSection(model: "이미지 섹션", items: model.makeCellData(from: $0))] }
            .asDriver(onErrorJustReturn: [])
        
        let errorMessage = Observable.merge(searchResult)
            .map { result -> String? in
                guard case .failure(let error) = result else { return nil }
                return error.localizedDescription
            }
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
        
        self.dataSource = dataSource
        self.errorMessage = errorMessage
    }
}
