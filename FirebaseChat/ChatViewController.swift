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
        
        let messageRef = Database.database().reference().child(MESSAGES)
        let childRef = messageRef.childByAutoId()
        
        let toId = user?.id
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: NSNumber = Date().timeIntervalSince1970 as NSNumber
        let values = [TEXT: inputTextField.text!,  TO_ID: toId!, FROM_ID: fromId, TIME_STAMP: timeStamp] as [String : Any]
        childRef.updateChildValues(values)
    }
}

//MARK:- Delegates
extension ChatViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
