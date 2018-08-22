//
//  UrlModel.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/15/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objc enum ValidationsState: Int {
    case valid
    case invalid
    case processing
}

class UrlModel: Object {
    
    @objc dynamic var ID = UUID().uuidString
    @objc dynamic var address: String = "" // url
    @objc dynamic var isValid: ValidationsState = .processing
    @objc dynamic var time: Double = 0

    convenience init(url: String) {
        self.init()
        address = url
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}
