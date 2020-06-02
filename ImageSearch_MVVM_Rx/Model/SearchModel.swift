//
//  SearchModel.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import Foundation

struct SearchModel {
    private let api: APIProtocol
    
    init(api: APIProtocol = API()) {
        self.api = api
    }
    
    func getImages(from query: Query) -> SearchResult {
        return api.getImages(query: query)
    }
    
    func makeCellData(from images: [Image]) -> [ImageCellData] {
        return images.compactMap { toImageCellData($0) }
    }
    
    private func toImageCellData(_ image: Image) -> ImageCellData? {
        guard let url = URL(string: image.imageURL) else { return nil }
        return ImageCellData(url: url, favorite: true)
    }
}
