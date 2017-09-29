//
//  Constants.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Application Constants
public struct AppConstants {
    static let networkCheckNotification = Notification.Name(rawValue: "NetworkCheckCompleted")
    static let outgoingChatCellId = "outCell"
    static let incomingChatCellId = "inCell"
}

//MARK:- Theme Colors
public struct Theme {
    
    /* Generic */
    static let navigationBarTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    static let navigationItemTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    static let profileImageBorderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
    
    /* Login/Register Scene */
    static let loginRegisterSceneBGColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    static let loginRegisterViewBGColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    static let loginRegisterButtonBGColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    
    /* Home Scene */
    static let timeLabelColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    /* Chat Scene */
    static let chatBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let receivedChatBubbleColor = #colorLiteral(red: 0.1925100756, green: 0.3395984017, blue: 0.7176792513, alpha: 1)
    static let receivedChatTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let receivedChatTimeLabelColor = #colorLiteral(red: 0.9585580584, green: 0.9585580584, blue: 0.9585580584, alpha: 1)
    static let sentChatBubbleColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    static let sentChatTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

//MARK:- Keys
public struct Keys {
    
    //Database
    static let users = "users"
    static let profileImages = "profileImages"
    static let name = "name"
    static let email = "email"
    static let password = "password"
    static let mobileNumber = "mobileNumber"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let text = "text"
    static let toId = "toId"
    static let fromId = "fromId"
    static let timeStamp = "timeStamp"
    static let userMessages = "userMessages"
    static let messageImages  = "messageImages"
    static let imageUrl = "imageUrl"
    static let width = "imageWidth"
    static let height = "imageHeight"
}

//MARK:- Texts
public struct Texts {
    
    //Application
    static let appTitle = "Firebase Chat"
    
    //Alerts
    
    /* Info*/
    static let registrationSuccess = "Successfully Signed Up. Please login to continue."
    
    /* Validations */
    static let emptyLoginCredentials = "Please enter your registered email and password to login."
    static let emptyLoginEmail = "Please enter your registered email to login."
    static let emptyLoginPassword = "Please enter your password to login."
    static let emptyRequiredFields = "Please enter the required details to proceed."
    static let emptyNames = "Name should not be empty."
    static let nameStartsWithDecimal = "Name should not start with a decimal."
    static let nameContainsSpecialCharacter = "Name should not contain special characters."
    static let emptyEmail = "Email is required."
    static let emptyMobileNumber = "Mobile number is required."
    static let invalidMobileNumber = "Please provide a valid mobile number."
    static let emptyPassword = "Password is required."
    static let emptyConfirmPassword = "Please confirm your password."
    static let weakPassword = "Password is weak. Please make it stronger."
    static let noUpperCaseInPassword = "Password must contain atleast one upper case alphabet."
    static let noLowerCaseInPassword = "Password must contain atleast one lower case alphabet."
    static let noDecimalInPassword = "Password must contain atleast one decimal."
    static let noSpecialCharacterInPassword = "Password must contain atleast one special character."
    static let nameInPassword = "Password should not contain a part of your name."
    static let passwordMismatch = "Passwords do not match."
    static let noProfileImage = "Please add a profile Image."
    
    /* Errors */
    static let internetUnavailable = "The Internet connection appears to be offline. Please check your network settings and try again."
    static let accountAlreadyExists = "Account already exists with a different credential. Please try again with a different email."
    static let credentialsAlreadyExists = "The credentials already exist. Please try again with a different email."
    static let emailAlreadyExists = "The email is already taken. Please try again with a different email."
    static let internalError = "There has been an internal server error. Please try again later"
    static let invalidCredentials = "Invalid credentials. Please try again."
    static let invalidEmail = "You've entered an invalid email. Please try again."
    static let tooManyRequests = "Too many requests. Please try again later."
    static let wrongPassword = "The password you've entered is wrong. Please try again."
    static let userNotFound = "User not found. Please check the email you've entered."
    static let userDisabled = "This user is temporarily disabled. Please contact the admin."
    static let unknownError = "Unknown Error. Please try again later or contact our team."
    static let imageTooLarge = "The profile image exceeds maximum size. Please use a smaller image to proceed."
    static let uploadCancelled = "Image uploading was cancelled by network. Please try again."
    static let bucketNotFound = "Image upload failed due to some internal server error. Please try again later."
}
