//
//  UrlTableViewCell.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/15/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import UIKit

class UrlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var validationView: UIView!
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    private var urlModel : UrlModel! {
        didSet {
            self.textLabel?.text = urlModel.address
            checkValidation(state: urlModel.isValid)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        activityIndicator.color = .black
        self.accessoryView = activityIndicator
        activityIndicator.startAnimating()
        
        validationView.layer.cornerRadius = validationView.frame.height/2
        validationView.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
    }
    
    // create cell from given urlModel
    func fromUrlModel(model: UrlModel) {
        urlModel = model
    }
    
    // set the correct color for validation state
    private func checkValidation(state : ValidationsState) {
        switch state {
        case .valid:
            validationView.backgroundColor = .green
            activityIndicator.stopAnimating()
        case .invalid:
            validationView.backgroundColor = .red
            activityIndicator.stopAnimating()
        case .processing:
            validationView.backgroundColor = .clear
            activityIndicator.startAnimating()
        }
    }
}
