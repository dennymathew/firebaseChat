//
//  Spinner.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 14/10/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

class Spinner {
    
    let spinner: UIActivityIndicatorView = {
        let uia = UIActivityIndicatorView()
        uia.translatesAutoresizingMaskIntoConstraints = false
        uia.activityIndicatorViewStyle = .gray
        return uia
    }()
    
    init(on view: UIView) {
        spinner.activityIndicatorViewStyle = .gray
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = false
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
