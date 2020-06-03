//
//  LocalImage.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RealmSwift

class LocalImage: Object {
    @objc dynamic var imageURL: String = ""
    @objc dynamic var favorite: Bool = false
    @objc dynamic var date: NSDate = NSDate()
    
    override class func primaryKey() -> String? {
        return "imageURL"
    }
}
