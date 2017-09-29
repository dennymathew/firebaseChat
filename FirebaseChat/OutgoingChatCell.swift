//
//  OutgoingChatCell.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 29/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

class OutgoingChatCell: UICollectionViewCell {
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var chatViewController: ChatViewController?
    
    var message: Message? {
        didSet {
            if let text = message?.text {
                textView.text = text
                bubbleViewWidthAnchor?.isActive = false
                bubbleViewWidthAnchor?.constant = (message?.text!.estimatedFrame().width)! + 40
                bubbleViewWidthAnchor?.isActive = true
                textView.isHidden = false
                messageImageView.isHidden = true
            } else if let imageUrl = message?.imageUrl {
                messageImageView.loadImageFromChache(with: imageUrl)
                messageImageView.isHidden = false
                textView.isHidden = true
                bubbleViewWidthAnchor?.isActive = false
                bubbleViewWidthAnchor?.constant = 200
                bubbleViewWidthAnchor?.isActive = true
            } else {
                messageImageView.isHidden = true
            }
            
            if let timeStamp = message?.timeStamp?.toTimeString("hh:mm a") {
                timeLabel.text = timeStamp
            }
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
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.chatBackgroundColor
        setUpViews()
    }
    
    
    func setUpViews() {
        
        addSubview(timeLabel)
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        bubbleView.addSubview(messageImageView)
        
        /* Time Label Constraints */
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        /* BubbleView Constraints */
        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        bubbleView.backgroundColor = Theme.sentChatBubbleColor
        
        /* TextView Constraints */
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 3).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        textView.textColor = Theme.sentChatTextColor
        
        /* ImageView Constraints */
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
    }
    
    func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.chatViewController?.performZooInForStartingImageView(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
