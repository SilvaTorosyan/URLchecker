//
//  SortManager.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation
import RealmSwift

class SortManager {
    
    var sortedType: SortType = .none
    
    static var sharedManager = SortManager()
    private init(){}
    
    func sortBy(type: SortType, models: [UrlModel]) -> [UrlModel] {
        self.sortedType = type
        switch type {
        case .nameAscending:
            return models.sorted { $0.address < $1.address }
        case .nameDescending:
            return models.sorted { $0.address > $1.address }
        case .reachability:
            return models.sorted { $0.isValid == .valid ? true : false && !($1.isValid == .valid ? true : false) }
        case .timeAscending:
            return models.sorted { $0.time < $1.time }
        case .timeDescending:
            return models.sorted { $0.time > $1.time }
        case .none:
            return models
        }
    }
}
