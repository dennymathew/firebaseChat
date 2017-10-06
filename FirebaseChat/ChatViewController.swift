//
//  ChatLogViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 16/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var startingFrame: CGRect?
    var imageBackground: UIView?
    var startingImageView: UIImageView?
    
    var messages = [Message]()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        /* Upload Image View */
        let uploadImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "upload_image_icon")
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
            return imageView
        }()
        
        containerView.addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalTo: containerView.heightAnchor, constant: -8).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -8).isActive = true
        
        /* Send Button */
        let sendButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setTitle("Send", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleTextChat), for: .touchUpInside)
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
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
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

//MARK:- Delegates
extension ChatViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextChat()
        return true
    }
}

//MARK:- CollectionView Datasource and Delegates
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80.0
        let message = messages[indexPath.item]
        if let text = message.text {
            height = text.estimatedFrame().height + 50.0
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight * 200 / imageWidth)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        if message.fromId == FirebaseHandler.uid() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.outgoingChatCellId, for: indexPath) as! OutgoingChatCell
            cell.chatViewController = self
            cell.message = message
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.incomingChatCellId, for: indexPath) as! IncomingChatCell
            cell.chatViewController = self
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    }
    
    func handleKeyboardDidShow(_ notification: Notification) {
        if messages.count > 0 {
            let lastIndex = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: lastIndex, at: .bottom, animated: true)
        }
    }
}
