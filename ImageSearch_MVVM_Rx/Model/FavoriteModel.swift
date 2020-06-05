//
//  FavoriteModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxSwift

struct FavoriteModel {
    private let storage: LocalStorage
    
    init(storage: LocalStorage = .init()) {
        self.storage = storage
    }
    
    func favorites() -> Observable<[LocalImage]> {
        return storage.favorites()
    }
    
    func delete(image: ImageCellData) -> Completable {
        if let image = storage.getImage(from: image.identity) {
            storage.delete(image: image)
        }
        return .empty()
    }
    
    func makeCellData(from images: [LocalImage]) -> [ImageCellData] {
        return images.compactMap { toImageCellData($0) }
    }
    
    private func toImageCellData(_ image: LocalImage) -> ImageCellData? {
        guard let url = URL(string: image.imageURL) else { return nil }
        return ImageCellData(url: url, favorite: image.favorite)
    }
}
