//
//  Image.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit

struct Image: Codable {
    var imageURL: String
    var thumbnailURL: String
    var siteName: String
    var width: Int
    var height: Int
    var favorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case siteName = "display_sitename"
        case width = "width"
        case height = "height"
    }
}
