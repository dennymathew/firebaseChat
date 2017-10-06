//
//  Validator.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 29/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation

enum FailureType {
    
    /* Name */
    case nameEmpty
    case nameStartsWithDecimal
    case nameContainsSpecialCharacter
    
    /* Email */
    case emailEmpty
    case emailConfirmEmpty
    case emailMismatch
    case emailInvalid
    
    /* Mobile Number */
    case mobileNumberEmpty
    case mobileNumberInvalid
    
    /* Password */
    case passwordEmpty
    case passwordConfirmEmpty
    case passwordWeak
    case passwordContainsNoUpperCase
    case passwordContainsNoLowerCase
    case passwordContainsNoDecimal
    case passwordContainsNoSpecialCharacter
    case passwordContainsName
    case passwordMismatch
}

class Validator: NSObject {
    
    static let alphabetsLowerCase = "abcdefghijklmnopqrstuvwxyz"
    static let alphabetsUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let decimals = "0123456789"
    
    static func validateName(_ name: String) -> (Bool, FailureType?) {
        
        //Empty
        if name.isEmpty {
            DLog("FAILURE: Name is Empty")
            return (false, .nameEmpty)
        }
        
        //Starts with Decimal
        if decimals.contains(name.first()) {
            DLog("FAILURE: Name Starts with Decimal")
            return (false, .nameStartsWithDecimal)
        }
        
        //Contains Special Character
        let characterset = CharacterSet(charactersIn: Validator.alphabetsUpperCase + Validator.alphabetsLowerCase + Validator.decimals + " ")
        if name.rangeOfCharacter(from: characterset.inverted) != nil {
            DLog("FAILURE: Name Contains Special Characters")
            return (false, .nameContainsSpecialCharacter)
        }
        
        //Valid
        return (true, nil)
    }
    
    static func validateEmails(_ email: String) -> (Bool, FailureType?) {
        
        //Empty
        if email.isEmpty {
            DLog("FAILURE: Email is empty")
            return (false, .emailEmpty)
        }
        
        //Invalid Format
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: email) {
            DLog("FAILURE: Email is invalid")
            return (false, .emailInvalid)
        }
        
        //Valid
        return (true, nil)
        
    }
    
    static func validateMobileNumber(_ mobileNumber: String) -> (Bool, FailureType?) {
        //Empty
        if mobileNumber.isEmpty {
            DLog("FAILURE: Mobile Number is Empty")
            return (false, .mobileNumberEmpty)
        }
        
        //Invalid
        let decimalSet = CharacterSet(charactersIn: Validator.decimals)
        if mobileNumber.rangeOfCharacter(from: decimalSet.inverted) != nil || mobileNumber.characters.count < 10 || mobileNumber.first() == "0" {
            DLog("FAILURE: Mobile Number is Invalid")
            return (false, .mobileNumberInvalid)
        }
        
        return (true, nil)
    }
    
    static func validatePassword(_ password: String, confirmPassword: String, name: String) -> (Bool, FailureType?) {
        
        //Empty
        if password.isEmpty {
            DLog("FAILURE: Password is Empty")
            return (false, .passwordEmpty)
        }
        
        if confirmPassword.isEmpty {
            DLog("FAILURE: Confirm Password is Empty")
            return (false, .passwordConfirmEmpty)
        }
        
        //Weak Password
        if password.characters.count < 6 {
            DLog("FAILURE: Password is Weak")
            return (false, .passwordWeak)
        }
        
        //Contains No Caps
        let capsCharacterSet = CharacterSet(charactersIn: Validator.alphabetsUpperCase)
        if password.rangeOfCharacter(from: capsCharacterSet) == nil {
            DLog("FAILURE: Password Contains No Upper Case")
            return (false, .passwordContainsNoUpperCase)
        }
        
        //Contains No Smalls
        let smallCharacterSet = CharacterSet(charactersIn: Validator.alphabetsLowerCase)
        if password.rangeOfCharacter(from: smallCharacterSet) == nil {
            DLog("FAILURE: Password Contains No Lower Case")
            return (false, .passwordContainsNoLowerCase)
        }
        
        //Contains No Decimals
        let decimalSet = CharacterSet(charactersIn: Validator.decimals)
        if password.rangeOfCharacter(from: decimalSet) == nil {
            DLog("FAILURE: Password Contains No Decimal")
            return (false, .passwordContainsNoDecimal)
        }
        
        //Contains No Special Characters
        let specialCharacterSet = CharacterSet(charactersIn: Validator.decimals + Validator.alphabetsUpperCase + Validator.alphabetsLowerCase).inverted
        if password.rangeOfCharacter(from: specialCharacterSet) == nil {
            DLog("FAILURE: Password Contains No Special Character")
            return (false, .passwordContainsNoSpecialCharacter)
        }
        
        //Contains Name
        if password.lowercased().contains(name.lowercased()) {
            DLog("FAILURE: Password Contains Name")
            return (false, .passwordContainsName)
        }
        
        //Mismatch
        if password != confirmPassword {
            DLog("FAILURE: Passwords Mismatch")
            return (false, .passwordMismatch)
        }
        
        //Valid Password
        return (true, nil)
    }
}
