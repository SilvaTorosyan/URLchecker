//
//  UrlTableViewCell.swift
//  URLChecker
//
//  Created by Paruyr Muradian on 8/15/18.
//  Copyright © 2018 Silva Torosyan. All rights reserved.
//

import UIKit

enum CellState {
    case valid
    case invalid
    case processing
}

class UrlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var urlLalbel: UILabel!
    @IBOutlet weak var validation: UIView!
    
    var state: CellState = .processing {
        didSet {
            switch state {
            case .valid:
                validation.backgroundColor = .green
                activityIndicator.stopAnimating()
            case .invalid:
                validation.backgroundColor = .red
                activityIndicator.stopAnimating()
            case .processing:
                validation.backgroundColor = .clear
                activityIndicator.startAnimating()
            }
        }
    }
        
    private var urlModel : UrlModel! {
        didSet {
            urlLalbel.text = urlModel.address
            checkValidation(state: urlModel.isValid)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        validation.layer.cornerRadius = validation.frame.height/2
        validation.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
    }
    
    // create cell from given urlModel
    func fromUrlModel(model: UrlModel) {
        urlModel = model
    }
    
    // set the correct color for validation state
    private func checkValidation(state : Bool) {
        self.state = state ? .valid : .invalid
    }
}
