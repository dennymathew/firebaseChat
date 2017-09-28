//
//  Message.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 17/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var text: String?
    var timeStamp: NSNumber?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
