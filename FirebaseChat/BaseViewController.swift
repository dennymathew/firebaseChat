//
//  BaseViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

//MARK:- Alert Model
public class AlertButton {
    let title: String
    let type: UIAlertActionStyle
    let action: (() -> Void)
    
    init(_ title: String = "OK", type: UIAlertActionStyle = .default, action: @escaping (() -> Void) = {}) {
        self.title = title
        self.type = type
        self.action = action
    }
}

public class Alert {
    let message : String
    let buttons : [AlertButton]?
    
    init(_ message: String, buttons: [AlertButton]?) {
        self.message = message
        self.buttons = buttons
    }
}

//MARK:- Base VC
class BaseViewController: UIViewController {
    
    //MARK:- Properties
    let mainSpinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.activityIndicatorViewStyle = .whiteLarge
        spin.hidesWhenStopped = true
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    var tapRec: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Alert
    func showAlert(_ alert: Alert) {
        
        let alertController = UIAlertController(title: Texts.appTitle, message: alert.message, preferredStyle: .alert)
        
        //Actions
        if let buttons = alert.buttons {
            if let primeButton = buttons.first {
                let primeAction = UIAlertAction(title: primeButton.title, style: primeButton.type, handler: { (action) in
                    primeButton.action()
                })
                
                alertController.addAction(primeAction)
            }
            
            if (alert.buttons?.count)! > 1 {
                let secButton = buttons[1]
                let secAction = UIAlertAction(title: secButton.title, style: secButton.type, handler: { (action) in
                    secButton.action()
                })
                
                alertController.addAction(secAction)
                
                if (alert.buttons?.count)! > 2 {
                    if let tertButton = buttons.last {
                        let tertAction = UIAlertAction(title: tertButton.title, style: tertButton.type, handler: { (action) in
                            tertButton.action()
                        })
                        
                        alertController.addAction(tertAction)
                    }
                }
            }
        }
            
        else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Activity Indicator
    func startProgress() {
        if view.subviews.contains(mainSpinner) {
            return
        }
        
        view.addSubview(mainSpinner)
        mainSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainSpinner.startAnimating()
    }
    
    func endProgress() {
        if view.subviews.contains(mainSpinner) && mainSpinner.isAnimating {
            mainSpinner.stopAnimating()
            mainSpinner.removeFromSuperview()
        }
    }
    
    //MARK:- Keyboard Handling
    func addTapRecognizer() {
        self.tapRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapRec!)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        if tapRec != nil {
            view.removeGestureRecognizer(tapRec!)
        }
        tapRec = nil
    }
}
