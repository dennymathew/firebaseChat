//
//  User.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: String?
    var name: String?
    var email: String?
    var mobileNumber: String?
    var profileImageUrl: String?
    
    init(_ dictionary: [String: Any]) {
        name = dictionary[Keys.name] as? String
        email = dictionary[Keys.email] as? String
        mobileNumber = dictionary[Keys.mobileNumber] as? String
        profileImageUrl = dictionary[Keys.profileImageUrl] as? String
    }
}
