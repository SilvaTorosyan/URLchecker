//
//  Validator.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation

class Validator {
    
    private static var sharedValidator : Validator = {
        let shared = Validator()
        return shared
    }()
    
    // shared singleton Validator
    static func shared() -> Validator {
        return sharedValidator
    }
    
    func checkValidation(url: UrlModel, completion: @escaping (Bool) -> ()) {
        NetworkManager.shared().request(url: url.address) { (state) in
            DispatchQueue.main.async {
                completion(state)
            }
        }
    }
}
