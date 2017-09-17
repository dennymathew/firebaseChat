//
//  ChatLogViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 16/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate {
    
    /* Input Text Field */
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var user: User? {
        didSet { navigationItem.title = user?.name }
    }

    //MARK- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        setUpInputComponents()
    }
    
    func setUpNavBar(with user: User) {
        
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
    }
    
    func setUpInputComponents() {
        
        /* ContainerView */
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        /* ContainerView Constraints */
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        /* Send Button */
        let sendButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setTitle("Send", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            return button
        }()
        
        /* Send Button Constraints */
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        /* TextField Constraints */
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        /* Separator Line View */
        let separatorLineView: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.9129520939, green: 0.9129520939, blue: 0.9129520939, alpha: 1)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        /* Separator View Constraints*/
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }
}

//MARK:- Handlers
extension ChatViewController {
    func handleSend() {
        
        if (inputTextField.text?.elementsEqual(""))! {
            return
        }
        
        let messageRef = Database.database().reference().child(MESSAGES).childByAutoId()
        let toId = user?.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: NSNumber = Date().timeIntervalSince1970 as NSNumber
        let values = [TEXT: inputTextField.text!,  TO_ID: toId!, FROM_ID: fromId, TIME_STAMP: timeStamp] as [String : Any]
        
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let messageId = messageRef.key
            let senderMessageRef = Database.database().reference().child(USER_MESSAGES).child(fromId)
            senderMessageRef.updateChildValues([messageId: 1])
            let recipientMessageRef = Database.database().reference().child(USER_MESSAGES).child(toId!)
            recipientMessageRef.updateChildValues([messageId: 1])
        }
    }
}

//MARK:- Delegates
extension ChatViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
