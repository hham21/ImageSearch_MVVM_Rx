//
//  SearchResponse.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit

struct SearchResponse: Codable {
    let meta: Meta
    let documents: [Image]
    
    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case documents = "documents"
    }
}
