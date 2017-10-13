//
//  FirebaseHandler.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 01/10/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

class FirebaseHandler: NSObject {
    
    /* Storage */
    private static let profileImagesDirectory = Storage.storage().reference().child(Keys.profileImages)
    private static let chatImagesDirectory = Storage.storage().reference().child(Keys.chat).child(Keys.messageImages)
    private static let chatVideosDirectory = Storage.storage().reference().child(Keys.chat).child(Keys.messageVideos)
    
    /* Video */
    private static let usersDirectory = Database.database().reference().child(Keys.users)
    private static let userMessagesDirectory = Database.database().reference().child(Keys.userMessages)
    private static let messagesDirectory = Database.database().reference().child(Keys.messages)
    
    /* Configure Firebase */
    static func configure() {
        FirebaseApp.configure()
    }
    
    /* Check Login Status */
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    /* Get UID of Current User */
    static func uid() -> String? {
        return isUserLoggedIn() == true ? (Auth.auth().currentUser?.uid)! : nil
    }
    
    /* Logout Current User */
    static func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            DLog("Error in logging user out: \(logoutError)")
        }
    }
    
    /* Create New User, Save Details in Database and Store Profile Image in Storage */
    static func registerUser(with name: String, email: String, mobileNumber: String, password: String, profileImage: UIImage, completion: @escaping (User?, Error?) -> ()) {
        
        //Create User
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let uid = user?.uid else {
                completion(nil, nil)
                return
            }
            
            //If Success Signing Up, Add profile Image
            if let uploadData = UIImageJPEGRepresentation(profileImage, 0.8) {
                profileImagesDirectory.child("\(uid).jpg").putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        completion(nil, error)
                        return
                    }
                    
                    //If Success Adding Profile Image, Save User Details in Firebase Database
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = [Keys.name: name, Keys.email: email, Keys.mobileNumber: mobileNumber, Keys.profileImageUrl: profileImageUrl] as [String : Any]
                        FirebaseHandler.registerUserIntoDatabase(with: uid, values: values, completion: { (success, error) in
                            if error != nil {
                                DLog("ERROR:- Couldn't save user in database: \(String(describing: error))")
                                //TODO: Remove User from the Auth Object
                                completion(nil, nil)
                                return
                            }
                            
                            //Create User Object
                            let user = User(values)
                            user.id = uid
                            completion(user, nil)
                        })
                    }
                })
            }
        }
    }
    
    /* Save User in Database */
    static func registerUserIntoDatabase(with uid: String, values: [String: Any], completion: @escaping (Bool, Error?) -> ()) {
        
        usersDirectory.child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                DispatchQueue.main.async {
                    completion(false, err)
                    return
                }
            }
            
            completion(true, nil)
            return
        })
    }
    
    /* Login User */
    static func loginUser(with email: String, password: String, completion: @escaping (Alert?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(FirebaseHandler.authErrorAlert(error!))
                return
            }
            completion(nil)
        }
    }
    
    /* Get User Details */
    static func user(with uid: String, response: @escaping (_ user: User?, _ error: Error?) -> ()) {
        usersDirectory.child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User(dictionary)
                user.id = uid
                user.setValuesForKeys(dictionary)
                response(user, nil)
            }
        }) { (error) in
            DLog("Error in fetching user data: \(error)")
            response(nil, error)
        }
    }
    
    /*Listen User Messages from All Partners */
    static func observUserMessages(added: @escaping (_ message: Message) -> (), removed: @escaping (_ messageId: String?) ->()) {
        guard let uid = FirebaseHandler.uid() else {
            return
        }
        
        let userMessageRef = userMessagesDirectory.child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            userMessageRef.child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                FirebaseHandler.message(with: messageId, message: { (message) in
                    added(message)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        userMessageRef.observe(.childRemoved, with: { (snapshot) in
            let messageId = snapshot.key
            removed(messageId)
            return
        })
    }
    
    /*Listen User Messages from a Single Partner */
    static func observePartnerMessages(with partnerId: String, observer: @escaping (_ message: Message) -> ()) {
        
        guard let uid = FirebaseHandler.uid() else {
            return
        }
        
        let userMessageRef = userMessagesDirectory.child(uid).child((partnerId))
        userMessageRef.observe(.childAdded, with: { (snapshot) in
        let messageId = snapshot.key
            FirebaseHandler.message(with: messageId, message: { (message) in
                observer(message)
            })
            
        }, withCancel: nil)
    }
    
    /* Remove Message Thread */
    static func deleteThread(from partnerId: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = FirebaseHandler.uid() else {
            completion(false)
            return
        }
        userMessagesDirectory.child(uid).child(partnerId).removeValue { (error, reference) in
            if error != nil {
                DLog("Error Removing Messages: \(String(describing: error))")
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
    
    /* Get Message from Database */
    static func message(with messageId: String, message: @escaping (_ message: Message) -> ()) {
        messagesDirectory.child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let msg = Message(dictionary)
                message(msg)
            }
        }, withCancel: nil)
    }
    
    /* Get All Users */
    static func fetchUsers(_ response: @escaping (_ user: User?) -> ()) {
        usersDirectory.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User(dictionary)
                user.id = snapshot.key
                response(user)
            }
        }) { (error) in
            DLog("ERROR: - \(error)")
            response(nil)
        }
    }
    
    /* Send Text Chat */
    static func sendChatMessage(_ toId: String, properties: [String: Any], completion: @escaping (_ success: Bool) -> ()) {
        
        guard let fromId = FirebaseHandler.uid() else {
            return
        }
        
        let messageRef = messagesDirectory.childByAutoId()
        let timeStamp: NSNumber = Date().timeIntervalSince1970 as NSNumber
        var values: [String : Any] = [Keys.toId: toId, Keys.fromId: fromId, Keys.timeStamp: timeStamp]
        
        properties.forEach({values[$0] = $1})
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                DLog(error!)
                completion(false)
                return
            }
            
            let messageId = messageRef.key
            let senderMessageRef = userMessagesDirectory.child(fromId).child(toId)
            senderMessageRef.updateChildValues([messageId: 1])
            let recipientMessageRef = userMessagesDirectory.child(toId).child(fromId)
            recipientMessageRef.updateChildValues([messageId: 1])
            
            completion(true)
        }
    }
    
    /* Send Image Chat */
    static func uploadChatImage(_ image: UIImage, response: @escaping (_ imageUrl: String?, _ error: Error?) -> ()) {
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            chatImagesDirectory.child(chatImageFileName()).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload Image!")
                    response(nil, error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    response(imageUrl, nil)
                }
            })
        }
    }
    
    /* Send Video */
    static func uploadChatVideo(_ fileUrl: URL, progress: @escaping (_ progress: String)-> (), completion: @escaping (_ downloadUrl: String?, _ thumbnailUrl: String?, _ thumbImage: UIImage?, _ error: Error?) -> ()) {
        let uploadTask = chatVideosDirectory.child(chatVideoFileName()).putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            
            if error != nil {
                DLog("ERROR: \(String(describing: error))")
                completion(nil, nil, nil, error)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                if let thumbnailImage = FirebaseHandler.thumbnailImage(for: fileUrl) {
                    if let thumbImageData = UIImageJPEGRepresentation(thumbnailImage, 0.8) {
                        chatImagesDirectory.child(chatImageThumbnailFileName()).putData(thumbImageData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                DLog("Error Uploading Thumbnail: \(String(describing: error))")
                                return
                            }
                            
                            if let thumbUrl = metadata?.downloadURL()?.absoluteString {
                                completion(videoUrl, thumbUrl, thumbnailImage, nil)
                            }
                        })
                    }
                }
                return
            }
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            progress(String(describing: snapshot.progress?.completedUnitCount))
        }
    }
    
    private static func thumbnailImage(for fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            DLog(error)
        }
        
        return nil
    }
    
    /* Handle Auth Errors */
    private static func authErrorAlert(_ error: Error) -> Alert {
        
        var message = Texts.unknownError
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            
            switch errorCode {
            case .accountExistsWithDifferentCredential:
                message = Texts.accountAlreadyExists
            case .credentialAlreadyInUse:
                message = Texts.credentialsAlreadyExists
            case .emailAlreadyInUse:
                message = Texts.emailAlreadyExists
            case .internalError:
                message = Texts.internalError
            case .invalidCredential:
                message = Texts.invalidCredentials
            case .invalidEmail:
                message = Texts.invalidEmail
            case .tooManyRequests:
                message = Texts.tooManyRequests
            case .wrongPassword:
                message = Texts.wrongPassword
            case .userNotFound:
                message = Texts.userNotFound
            case .userDisabled:
                message = Texts.userDisabled
            case .networkError:
                message = Texts.internetUnavailable
            default:
                message = Texts.unknownError
            }
        }
        
        return Alert(message, buttons: nil)
    }
    
    /* Handle Storage Errors */
    private static func storageErrorAlert(_ error: Error) -> Alert {
        
        var message = Texts.unknownError
        if let errorCode = StorageErrorCode(rawValue: error._code) {
            switch errorCode {
            case .bucketNotFound:
                message = Texts.bucketNotFound
            case .cancelled:
                message = Texts.uploadCancelled
            case .downloadSizeExceeded:
                message = Texts.imageTooLarge
            default:
                message = Texts.unknownError
            }
        }
        
        return Alert(message, buttons: nil)
    }
}
