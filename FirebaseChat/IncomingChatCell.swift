//
//  ChatMessageCell.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 18/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class IncomingChatCell: UICollectionViewCell {
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var timeLabelRightAnchor: NSLayoutConstraint?
    var timeLabelLeftAnchor: NSLayoutConstraint?
    
    var message: Message? {
        didSet {
            if let text = message?.text {
                textView.text = text
                bubbleViewWidthAnchor?.isActive = false
                bubbleViewWidthAnchor?.constant = (message?.text!.estimatedFrame().width)! + 40
                bubbleViewWidthAnchor?.isActive = true
            }
            
            if let timeStamp = message?.timeStamp?.toTimeString("hh:mm a") {
                timeLabel.text = timeStamp
            }
            
            //TODO: Add Profile Image
        }
    }
   
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        tv.textAlignment = .natural
        tv.adjustsFontForContentSizeCategory = true
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "firebase_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.chatBackgroundColor
        
        if self.reuseIdentifier == "outCell" {
            setUpOutgoingChatView()
        } else {
            setUpIncomingChatView()
        }
    }
    

    func setUpOutgoingChatView() {
        
        addSubview(timeLabel)
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        
        /* Time Label Constraints */
        timeLabelRightAnchor?.isActive = false
        timeLabelRightAnchor = timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        timeLabelRightAnchor?.isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        /* BubbleView Constraints */
        bubbleViewWidthAnchor?.isActive = false
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleViewRightAnchor?.isActive = false
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2)
        bubbleViewRightAnchor?.isActive = true
        bubbleView.backgroundColor = Theme.sentChatBubbleColor
        textView.textColor = Theme.sentChatTextColor
        
        /* TextView Constraints */
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 3).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
    }
    
    func setUpIncomingChatView() {
        
        addSubview(timeLabel)
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        addSubview(profileImageView)
        
        //Profile Image View
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.alpha = 1.0
        
        //Time Label
        timeLabelLeftAnchor?.isActive = false
        timeLabelLeftAnchor = timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 42)
        timeLabelLeftAnchor?.isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        timeLabel.text = message?.timeStamp?.toTimeString("hh:mm a")
        
        //Bubble View
        bubbleViewWidthAnchor?.isActive = false
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleViewLeftAnchor?.isActive = false
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = true
        bubbleView.backgroundColor = Theme.receivedChatBubbleColor
        textView.textColor = Theme.receivedChatTextColor
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
