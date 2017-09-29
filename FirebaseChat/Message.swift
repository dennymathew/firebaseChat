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
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(_ dictionary: [String: Any]) {
        super.init()
        fromId = dictionary[Keys.fromId] as? String
        toId = dictionary[Keys.toId] as? String
        text = dictionary[Keys.text] as? String
        timeStamp = dictionary[Keys.timeStamp] as? NSNumber
        imageUrl = dictionary[Keys.imageUrl] as? String
        imageHeight = dictionary[Keys.height] as? NSNumber
        imageWidth = dictionary[Keys.width] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
