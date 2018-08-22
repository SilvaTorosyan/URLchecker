//
//  NetworkManager.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation

class NetworkManager {

    static var sharedManager = NetworkManager()
    private init() {}
    
    func request(url: String, completion: @escaping (Bool) -> Void ) {
        
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false)
            }
            if (response as? HTTPURLResponse) != nil {
                completion(true)
            }
        }
        task.resume()
    }
}
