//
//  LoginViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Logout Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleLogout() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
