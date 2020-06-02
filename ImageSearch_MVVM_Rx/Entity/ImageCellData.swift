//
//  ImageCellData.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RxDataSources

struct ImageCellData {
    var url: URL
    var favorite: Bool
}

extension ImageCellData: Equatable, IdentifiableType {
    var identity: String {
        return url.absoluteString
    }
}
