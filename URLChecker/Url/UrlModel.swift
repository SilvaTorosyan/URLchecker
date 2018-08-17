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

class UrlModel: Object {
    
    @objc dynamic var ID = UUID().uuidString
    @objc dynamic var address: String = "" // url
    @objc dynamic var isValid: Bool = false // is url valid or not
    @objc dynamic var time: Float = 0

    init(url: String) {
        address = url
        super.init()
    }
    
    required init() {
//        fatalError("init() has not been implemented")
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
        super.init(value: value, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}
