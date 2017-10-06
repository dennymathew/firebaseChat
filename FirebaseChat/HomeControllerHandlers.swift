//
//  HomeControllerHandlers.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 01/10/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Handlers
extension HomeViewController {
    
    func handleLogout() {
        
        FirebaseHandler.logoutUser()
        
        let loginController = LoginViewController()
        loginController.homeVC = self
        loginController.modalTransitionStyle = .crossDissolve
        present(loginController, animated: true, completion: nil)
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageViewController()
        newMessageController.homeVc = self
        navigationController?.present(newMessageController, animated: true)
    }
    
    func showChatLogController(with user: User) {
        let chatController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        self.navigationController?.show(chatController, sender: self)
    }
    
    func observeMessges() {
        FirebaseHandler.observUserMessages { (message) in
            if let chatPartnerId = message.chatPartnerId(){
                self.messageDictionary[chatPartnerId] = message
                self.attemptReloadTable()
            }
        }
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func handleReloadTable() {
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return Int(message1.timeStamp!) > Int(message2.timeStamp!)
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
