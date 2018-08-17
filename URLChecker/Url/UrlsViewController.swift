//
//  UrlsViewController.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/15/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UrlsViewController: UIViewController {
    
    private let cellIdentifier = "cellID"
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var urlsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    var results: Results<UrlModel>?
    var resultsArray = Array<UrlModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureData()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        urlsTableView.delegate = self
        urlsTableView.dataSource = self
        urlsTableView.register(UINib(nibName: "UrlTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        urlsTableView.estimatedRowHeight = 100
    }
    
    func configureData() {
        results = DBManager.getAllObjects()
        resultsArray = SortManager.shared().sortBy(type: SortManager.shared().sortedType, models: results!)
    }
    
    func reloadData() {
        results = DBManager.getAllObjects()
        for url in results! {
            Validator.shared().checkValidation(url: url, completion: { state in
                DBManager.updateModelWithValidation(state: state, model: url)
            })
        }
        resultsArray = SortManager.shared().sortBy(type: SortManager.shared().sortedType, models: results!)
    }
    
    func configureUI() {
        addButton.layer.cornerRadius = 20
        sortButton.layer.cornerRadius = 20
        
//        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        search.obscuresBackgroundDuringPresentation = false
//        search.searchBar.placeholder = "Type something here to search"
//        navigationItem.searchController = search
    }
    
    func createAlertController() {
        let alertController = UIAlertController(title: "Add New URL", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.text = "https://"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            self.addNewUrl(url: textField.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in})
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        reloadData()
        urlsTableView.reloadData()
    }
    
    @IBAction func addAction(_ sender: Any) {
        createAlertController()
    }
    
    func addNewUrl(url: String) {
        let model = DBManager.createModelFrom(url: url)
        Validator.shared().checkValidation(url: model, completion: { state in
            DBManager.updateModelWithValidation(state: state, model: model)
            self.configureData()
            self.urlsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sort") {
            let vc:SortViewController = segue.destination as! SortViewController
            vc.delegate = self
        }
    }
}

extension UrlsViewController : SortViewControllerProtocol {
    
    func didSelectSortType(type: SortType) {
        resultsArray = SortManager.shared().sortBy(type: type, models: results!)
        urlsTableView.reloadData()
    }
}

extension UrlsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBManager.deleteModel(model: self.resultsArray.remove(at: indexPath.row))
            self.urlsTableView.deleteRows(at: [indexPath], with: .none)
            
        }
    }
}

extension UrlsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.urlsTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! UrlTableViewCell
        cell.fromUrlModel(model: self.resultsArray[indexPath.row])
        return cell
    }
}

extension UrlsViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchBar.text = ""
        configureData()
        urlsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        SearchManager.shared().searchWith(text: searchBar.text!)
//        searchBar.text = ""
//        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = SearchManager.shared().searchWith(text: searchText, inArray: resultsArray)
        urlsTableView.reloadData()
    }
}



