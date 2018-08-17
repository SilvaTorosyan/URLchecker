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
    
    private static var sharedManager : SortManager = {
        let shared = SortManager()
        return shared
    }()
    
    // shared singleton manager
    static func shared() -> SortManager {
        return sharedManager
    }
    
    func sortBy(type: SortType, models: Results<UrlModel>) -> [UrlModel] {
        self.sortedType = type
        switch type {
        case .nameAscending:
            return models.sorted { $0.address < $1.address }
        case .nameDescending:
            return models.sorted { $0.address > $1.address }
        case .reachability:
            return models.sorted { $0.isValid && !$1.isValid }
        case .time:
            return models.sorted { $0.time < $1.time }
        case .none:
            return Array(models)
        }
    }
}
