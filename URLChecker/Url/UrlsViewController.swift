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
    
    let viewModel = UrlViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var urlsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    lazy var messageAlert = UIAlertController()
    lazy var errorAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        viewModel.configureData()
        createAlertController()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        urlsTableView.delegate = self
        urlsTableView.dataSource = self
        urlsTableView.estimatedRowHeight = 100
    }
    
    func configureUI() {
        addButton.layer.cornerRadius = 20
        sortButton.layer.cornerRadius = 20
    }
    
    func createAlertController() {
        messageAlert = UIAlertController(title: "Add New URL", message: "", preferredStyle: .alert)
        messageAlert.addTextField { (textField : UITextField!) -> Void in
            textField.text = "https://"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = self.messageAlert.textFields?.first
            self.addNewUrl(url: textField!.text!)
            textField!.text = "https://"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
            let textField = self.messageAlert.textFields?.first
            textField!.text = "https://"
        })
        messageAlert.addAction(saveAction)
        messageAlert.addAction(cancelAction)
    }
    
    func createErrorAlert() {
        errorAlert = UIAlertController(title: "Can not delete", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: {alert -> Void in})
        errorAlert.addAction(okAction)
    }
    
    func addNewUrl(url: String) {
        viewModel.addNewUrlModel(url: url) {
            self.urlsTableView.reloadData()
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        viewModel.reloadData(completion: {index in
            self.urlsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        })
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.present(messageAlert, animated: true, completion: nil)
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
        viewModel.sortByType(type: type) { () in
            self.urlsTableView.reloadData()
        }
    }
}

extension UrlsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if viewModel.dataSource[indexPath.row].isValid == .processing {
                self.present(errorAlert, animated: true, completion: nil)
            }
            else {
                DBManager.deleteModel(model: viewModel.dataSource.remove(at: indexPath.row))
                self.urlsTableView.deleteRows(at: [indexPath], with: .none)
            }
        }
    }
}

extension UrlsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.urlsTableView.dequeueReusableCell(withIdentifier: "cellID") as! UrlTableViewCell
        cell.fromUrlModel(model: viewModel.dataSource[indexPath.row])
        return cell
    }
}

extension UrlsViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.configureData()
        urlsTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.serachWithText(text: searchText) {
            self.urlsTableView.reloadData()
        }
    }
}
