//
//  BaseViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

//MARK:- ALERT STRUCTURES
public struct AlertTextField {
    let text : String
}

public struct AlertButton {
    let title : String
    let action : (UIAlertAction) -> Void?
    let type : UIAlertActionStyle
}

public struct Alert {
    
    let title : String
    let message : String
    var buttons : [AlertButton]?
    var textBoxes : [AlertTextField]?
}

//MARK:- Base VC
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(_ alert: Alert) {
        
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        
        //Actions
        if (alert.buttons != nil) {
            let primaryAction = UIAlertAction(title: alert.buttons?.first?.title, style: (alert.buttons?.first?.type)!, handler: alert.buttons?.first?.action as? (UIAlertAction) -> Void)
            alertController.addAction(primaryAction)
            
            if (alert.buttons?.count)! > 1 {
                let secondaryAction = UIAlertAction(title: alert.buttons?[1].title, style: (alert.buttons?[1].type)!, handler: alert.buttons?[1].action as? (UIAlertAction) -> Void)
                alertController.addAction(secondaryAction)
            }
            
            if (alert.buttons?.count)! > 2 {
                let tertioryAction = UIAlertAction(title: alert.buttons?[2].title, style: (alert.buttons?[2].type)!, handler: alert.buttons?[2].action as? (UIAlertAction) -> Void)
                alertController.addAction(tertioryAction)
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
}
