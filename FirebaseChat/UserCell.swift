//
//  UserCell.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 17/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    //MARK:- Properties
    var message: Message? {
        didSet {
            
            setUpNameAndProfileImage()
            
            if let text = message?.text {
                detailTextLabel?.text = text
            }
            
            if let seconds = message?.timeStamp?.doubleValue {
                let timeSTampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timeSTampDate)
            }
        }
    }
    
    var user: User? {
        didSet {
            if let name = user?.name, let email = user?.email {
                textLabel?.text = name
                detailTextLabel?.text = email
            }
            
            if let imageUrl = user?.profileImageUrl {
                self.profileImageView.loadImageFromChache(with: imageUrl)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firebase_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.timeLabelColor
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:- Initializers
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: profileImageView.frame.width + 20, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.width + 20, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Methods
    private func setUpNameAndProfileImage() {
        
        guard let partnerId = message?.chatPartnerId() else {
            return
        }
        
        let userRef = Database.database().reference().child(Keys.users).child(partnerId)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: Any] {
            self.textLabel?.text = dictionary[Keys.name] as? String
                if let profileImageUrl = dictionary[Keys.profileImageUrl] as? String {
                    self.profileImageView.loadImageFromChache(with: profileImageUrl)
                }
            }
        })
    }
}
