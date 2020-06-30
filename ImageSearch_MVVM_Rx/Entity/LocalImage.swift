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
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    override class func primaryKey() -> String? {
        return "imageURL"
    }
}
