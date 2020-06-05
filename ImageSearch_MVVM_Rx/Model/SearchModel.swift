//
//  SearchModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxSwift
import RxCocoa

struct SearchModel {
    private var disposeBag: DisposeBag = .init()
    
    private let api: APIProtocol
    private let storage: LocalStorage
    private let localSaved: BehaviorRelay<[String: LocalImage]> = .init(value: [:])
    
    init(api: APIProtocol = API(), storage: LocalStorage = .init()) {
        self.api = api
        self.storage = storage
        
        storage.favorites()
            .map { $0.reduce(into: [:], { $0[$1.imageURL] = $1 }) }
            .bind(to: localSaved)
            .disposed(by: disposeBag)
    }
    
    func getImages(from query: Query) -> SearchResult {
        return api.getImages(query: query)
    }
    
    func favorites() -> Observable<[LocalImage]> {
        return storage.favorites()
    }
    
    func toggle(image: ImageCellData) -> Completable {
        if let localImage = localSaved.value[image.identity], image.favorite {
            storage.delete(image: localImage)
        } else {
            let localImage = LocalImage()
            localImage.imageURL = image.identity
            localImage.favorite = image.favorite
            storage.add(image: localImage)
        }
        return .empty()
    }
    
    func makeCellData(from images: [Image]) -> [ImageCellData] {
        return images.compactMap { toImageCellData($0) }
    }
    
    private func toImageCellData(_ image: Image) -> ImageCellData? {
        guard let url = URL(string: image.imageURL) else { return nil }
        let favorite = localSaved.value.keys.contains(image.imageURL)
        return ImageCellData(url: url, favorite: favorite)
    }
}
