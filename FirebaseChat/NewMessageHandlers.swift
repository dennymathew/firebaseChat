//
//  NewMessageHandlers.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 01/10/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation

//MARK:- Handlers
extension NewMessageViewController {
    func fetchUsers() {
        FirebaseHandler.fetchUsers { (fetchedUser) in
            if let user = fetchedUser {
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
