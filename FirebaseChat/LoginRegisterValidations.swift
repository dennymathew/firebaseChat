//
//  LoginRegisterValidations.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 29/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation

extension LoginViewController {
    //MARK:- User Inputs Validation Methods
    func validateLoginInputs() -> Bool {
        //Safe Side
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            DLog("Invalid Inputs")
            return false
        }
        
        //Empty Fields
        if email.isEmpty && password.isEmpty {
            stopSpinner()
            showAlert(Alert(Texts.emptyLoginCredentials, buttons: nil))
            return false
        }
        
        var success = true
        var cause: FailureType?
        var message: String?
        
        //Email
        (success, cause) = Validator.validateEmails(email)
        
        if !success {
            switch cause {
            case .emailEmpty?:
                message = Texts.emptyLoginEmail
                
            case .emailInvalid?:
                message = Texts.invalidEmail
                
            default:
                DLog("Unknown Error!")
            }
            
            stopSpinner()
            showAlert(Alert(message!, buttons: nil))
            return false
        }
        
        //Password
        if password.isEmpty {
            showAlert(Alert(Texts.emptyLoginPassword, buttons: nil))
            return false
        }
        
        return true
    }
    
    func validateRegistrationInputs() -> Bool {
        //Safe Side
        guard let name = nameTextField.text, let email = emailTextField.text, let mobileNumber = mobileNumberTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            DLog("Invalid Inputs")
            self.stopSpinner()
            self.showAlert(Alert(Texts.unknownError, buttons: nil))
            return false
        }
        
        //Empty Fields
        if name.isEmpty && email.isEmpty && password.isEmpty && mobileNumber.isEmpty {
            stopSpinner()
            showAlert(Alert(Texts.emptyRequiredFields, buttons: nil))
            return false
        }
        
        var success = true
        var cause: FailureType?
        var message: String?
        
        //Name
        (success, cause) = Validator.validateName(name)
        
        if !success {
            switch cause {
            case .nameEmpty?:
                message = Texts.emptyNames
                
            case .nameStartsWithDecimal?:
                message = Texts.nameStartsWithDecimal
                
            case .nameContainsSpecialCharacter?:
                message = Texts.nameContainsSpecialCharacter
                
            default:
                DLog("Unknown Error!")
            }
            
            stopSpinner()
            showAlert(Alert(message!, buttons: nil))
            return false
        } else {
            self.user?.name = name
        }
        
        //Email
        (success, cause) = Validator.validateEmails(email)
        
        if !success {
            switch cause {
            case .emailEmpty?:
                message = Texts.emptyEmail
                
            case .emailInvalid?:
                message = Texts.invalidEmail
                
            default:
                DLog("Unknown Error!")
            }
            
            stopSpinner()
            showAlert(Alert(message!, buttons: nil))
            return false
        } else {
            self.user?.email = email
        }
        
        //Mobile Number
        (success, cause) = Validator.validateMobileNumber(mobileNumber)
        
        if !success {
            switch cause {
            case .mobileNumberEmpty?:
                message = Texts.emptyMobileNumber
                
            case .mobileNumberInvalid?:
                message = Texts.invalidMobileNumber
                
            default:
                DLog("Unknown Error!")
            }
            
            stopSpinner()
            showAlert(Alert(message!, buttons: nil))
            return false
        } else {
            self.user?.mobileNumber = mobileNumber
        }
        
        //Password
        (success, cause) = Validator.validatePassword(password, confirmPassword: confirmPassword, name: name)
        
        if !success {
            switch cause {
            case .passwordEmpty?:
                message = Texts.emptyPassword
                
            case .passwordConfirmEmpty?:
                message = Texts.emptyConfirmPassword
                
            case .passwordWeak?:
                message = Texts.weakPassword
                
            case .passwordContainsNoUpperCase?:
                message = Texts.noUpperCaseInPassword
                
            case .passwordContainsNoLowerCase?:
                message = Texts.noLowerCaseInPassword
                
            case .passwordContainsNoDecimal?:
                message = Texts.noDecimalInPassword
                
            case .passwordContainsNoSpecialCharacter?:
                message = Texts.noSpecialCharacterInPassword
                
            case .passwordContainsName?:
                message = Texts.nameInPassword
                
            case .passwordMismatch?:
                message = Texts.passwordMismatch
                
            default:
                DLog("Unknown Error!")
            }
            
            stopSpinner()
            showAlert(Alert(message!, buttons: nil))
            return false
        }
        
        if !profileImageAdded {
            self.stopSpinner()
            self.dismissKeyboard()
            self.showAlert(Alert(Texts.noProfileImage, buttons: nil))
            return false
        }
        
        return true
    }
}
