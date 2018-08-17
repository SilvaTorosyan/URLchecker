//
//  SearchManager.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation

class SearchManager {
    
    private static var sharedManager : SearchManager = {
        let shared = SearchManager()
        return shared
    }()
    
    // shared singleton manager
    static func shared() -> SearchManager {
        return sharedManager
    }
    
    func searchWith(text: String, inArray array: [UrlModel]) -> [UrlModel] {
        return array.filter({$0.address.contains(text)})
    }
}
