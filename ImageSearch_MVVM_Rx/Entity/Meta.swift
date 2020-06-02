//
//  Meta.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit

struct Meta: Codable {
    let pageableCount: Int
    let totalCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}
