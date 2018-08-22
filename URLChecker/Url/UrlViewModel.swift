//
//  UrlViewModel.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/21/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import Foundation
import RealmSwift

class UrlViewModel {
    
    private var results = Array<UrlModel>()
    var dataSource = Array<UrlModel>()

    func configureData() {
        results = Array(DBManager.getAllObjects())
        dataSource = SortManager.sharedManager.sortBy(type: SortManager.sharedManager.sortedType, models: results)
    }

    func reloadData(completion: @escaping (Int)->()) {
        results = Array(DBManager.getAllObjects())
        dataSource = SortManager.sharedManager.sortBy(type: SortManager.sharedManager.sortedType, models: results)
        for url in dataSource {
            Validator.sharedValidator.checkValidation(url: url, completion: { state, time in
                DBManager.updateModelWithValidation(state: state, andTime: time , model: url)
                completion(self.dataSource.index(of: url)!)
            })
        }
    }
    
    func addNewUrlModel(url: String, completion: @escaping ()->()) {
        let model = DBManager.createModelFrom(url: url)
        self.configureData()
        completion()
        Validator.sharedValidator.checkValidation(url: model, completion: { state, time  in
            DBManager.updateModelWithValidation(state: state, andTime: time, model: model)
            self.configureData()
            completion()
        })
    }
    
    func sortByType(type: SortType, completion: @escaping ()->()) {
        dataSource = SortManager.sharedManager.sortBy(type: type, models: results)
        completion()
    }
    
    private func searchWith(text: String, inArray array: [UrlModel]) -> [UrlModel] {
        if text != "" {
            return array.filter({$0.address.localizedCaseInsensitiveContains(text)})
        } else {
            return results
        }
    }
    
    func serachWithText(text: String, completion: @escaping ()->()) {
        dataSource = self.searchWith(text: text, inArray: results)
        completion()
    }
}
