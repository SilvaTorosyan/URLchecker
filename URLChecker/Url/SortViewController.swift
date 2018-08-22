//
//  SortViewController.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/16/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import UIKit
import Foundation

protocol SortViewControllerProtocol: class {
    func didSelectSortType(type: SortType)
}

enum SortType: String {
    case nameAscending = "Sort by name ascending"
    case nameDescending = "Sort by name descending"
    case reachability = "Sort by reachability"
    case timeAscending = "Sort by time ascending"
    case timeDescending = "Sort by time descending"
    case none = "Not Sort"
}

class SortViewController: UIViewController {
    
    let cases = [SortType.nameAscending, SortType.nameDescending, SortType.reachability, SortType.timeAscending, SortType.timeDescending, SortType.none]

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SortViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectSortType(type: cases[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension SortViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell")
        cell?.textLabel?.text = cases[indexPath.row].rawValue
        return cell!
    }
    
}
