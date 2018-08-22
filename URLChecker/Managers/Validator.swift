//
//  Validator.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation

class Validator {
    
    static var sharedValidator = Validator()
    private init() {}
    
    func checkValidation(url: UrlModel, completion: @escaping (Bool, TimeInterval) -> ()) {
        let startDate = Date()
        NetworkManager.sharedManager.request(url: url.address) { (state) in
            DispatchQueue.main.async {
                let requestTime = Date().timeIntervalSince(startDate)
                completion(state, requestTime)
            }
        }
    }
}
