//
//  CasheManager.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBManager {
    
    private static var _realm: Realm!
    private static var realm: Realm {
        get {
            if _realm != nil {
                return _realm
            }
            _realm = try! Realm()
            return _realm
        }
    }
    
    static func createModelFrom(url: String) -> UrlModel {
        let model = UrlModel(url: url)
        try! realm.write {
            realm.add(model)
        }
        return model
    }
    
    static func updateModelWithValidation(state: Bool, model: UrlModel) {
        try! realm.write {
            model.isValid = state
//            model.time = time
        }
    }
    
    static func deleteModel(model: UrlModel) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
    static func getAllObjects() -> Results<UrlModel> {
        return realm.objects(UrlModel.self)
    }
}
