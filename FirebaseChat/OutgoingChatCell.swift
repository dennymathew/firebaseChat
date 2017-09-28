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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.chatBackgroundColor
        setUpViews()
    }
    
    
    func setUpViews() {
        
        addSubview(timeLabel)
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
