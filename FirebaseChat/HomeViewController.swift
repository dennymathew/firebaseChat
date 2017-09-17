//
//  LoginViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController {
    
    let cellId = "cellId"
    var messages = [Message]()
    var messageDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetUpNavBar()
        }
    }
    
    func fetchUserAndSetUpNavBar() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child(USERS).child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = uid
                user.setValuesForKeys(dictionary)
                self.setUpNavBar(with: user)
            }
        }) { (error) in
            print(error)
        }
    }
    
    func setUpNavBar(with user: User) {
        
        self.messages.removeAll()
        self.messageDictionary.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        observeUserMessages()
        
        let titleView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "firebase_icon")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            imageView.layer.borderWidth = 1.0
            return imageView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = user.name
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        if let imageUrl = user.profileImageUrl {
            profileImageView.loadImageFromChache(with: imageUrl)
        }
        
        titleView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        navigationItem.titleView = titleView
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLogController)))
    }
    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        print("LOGGED IN USER ID: \(uid)")
        let userMessageRef = Database.database().reference().child(USER_MESSAGES).child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            print("MESSAGE ID:- \(messageId)")
            let messageRef = Database.database().reference().child(MESSAGES).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    
                    guard let chatPartnerId = message.fromId == Auth.auth().currentUser?.uid ? message.toId : message.fromId else {
                        return
                    }
                    
                    self.messageDictionary[chatPartnerId] = message
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return Int(message1.timeStamp!) > Int(message2.timeStamp!)
                    })
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
}

//MARK:- Handlers
extension HomeViewController {
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
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
}

//MARK:- Table View Data Source and Delegates
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let message = messages[indexPath.row]
        let partnerUid = message.fromId == Auth.auth().currentUser?.uid ? message.toId! : message.fromId!
        Database.database().reference().child(USERS).child(partnerUid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let partner = User()
                partner.id = partnerUid
                partner.setValuesForKeys(dictionary)
                chatController.user = partner
                chatController.setUpNavBar(with: partner)
                DispatchQueue.main.async {
                    self.navigationController?.show(chatController, sender: self)
                }
            }
        }) { (error) in
            print(error)
        }
    }
}
