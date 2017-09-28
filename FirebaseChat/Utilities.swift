//
//  Utilities.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 28/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import Firebase

//MARK:- Custom Logger
public func DLog(_ items: Any...) {
    #if DEBUG
        print(items)
    #endif
}

//MARK:- Firebase: Internet Connection Check
var isNetworkReachable = true
var networkCheckCount = 0
public func performNetworkCheck() {
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    connectedRef.observe(.value, with: { snapshot in
        if let reachability = snapshot.value as? Bool {
            isNetworkReachable = reachability
            DLog("Network Reachablility: \(String(describing: isNetworkReachable))")
            networkCheckCount += 1
            if networkCheckCount > 1 {
                NotificationCenter.default.post(name: AppConstants.networkCheckNotification, object: nil)
            }
        }
    })
}
