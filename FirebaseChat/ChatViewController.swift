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
    
    //MARK:- Properties
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let mainSpinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.activityIndicatorViewStyle = .whiteLarge
        spin.hidesWhenStopped = true
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
        
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }

    var messages = [Message]()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
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
        containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        /* Separator Line View */
        let separatorLineView: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        /* Separator View Constraints*/
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1.05).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
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
    
    func setUpCollectionView() {
        collectionView?.register(OutgoingChatCell.self, forCellWithReuseIdentifier: AppConstants.outgoingChatCellId)
        collectionView?.register(IncomingChatCell.self, forCellWithReuseIdentifier: AppConstants.incomingChatCellId)
        collectionView?.backgroundColor = Theme.chatBackgroundColor
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.keyboardDismissMode = .interactive
    }
}

//MARK:- Handlers
extension ChatViewController {
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessageRef = Database.database().reference().child(Keys.userMessages).child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child(Keys.messages).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    
                    guard let chatPartnerId = message.chatPartnerId() else {
                        return
                    }
                    
                    if chatPartnerId == self.user?.id {
                        self.messages.append(message)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return Int(message2.timeStamp!) > Int(message1.timeStamp!)
                        })
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            let lastIndex = IndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView?.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                        }
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func handleSend() {
        
        if (inputTextField.text?.elementsEqual(""))! {
            return
        }
        
        let messageRef = Database.database().reference().child(Keys.messages).childByAutoId()
        let toId = user?.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: NSNumber = Date().timeIntervalSince1970 as NSNumber
        let values = [Keys.text: inputTextField.text!,  Keys.toId: toId!, Keys.fromId: fromId, Keys.timeStamp: timeStamp] as [String : Any]
        
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                DLog(error!)
                return
            }
            
            let messageId = messageRef.key
            let senderMessageRef = Database.database().reference().child(Keys.userMessages).child(fromId)
            senderMessageRef.updateChildValues([messageId: 1])
            let recipientMessageRef = Database.database().reference().child(Keys.userMessages).child(toId!)
            recipientMessageRef.updateChildValues([messageId: 1])
            
            DispatchQueue.main.async {
                self.inputTextField.text = ""
                self.collectionView?.reloadData()
            }
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

//MARK:- CollectionView Datasource and Delegates
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80.0
        if let text = messages[indexPath.item].text {
            height = text.estimatedFrame().height + 50.0
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        if message.fromId == Auth.auth().currentUser?.uid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.outgoingChatCellId, for: indexPath) as! OutgoingChatCell
            cell.message = message
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.incomingChatCellId, for: indexPath) as! IncomingChatCell
            cell.message = message
            return cell
        }
    }
}

extension ChatViewController {
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
    
    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as! Double
        containerViewBottomAnchor?.constant = -(keyboardFrame?.height)!
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as! Double
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
