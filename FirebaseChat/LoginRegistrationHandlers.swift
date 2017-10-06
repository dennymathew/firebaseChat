//
//  LoginRegistrationHandlers.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 29/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Handlers
extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Handlers
    func handleRegisterLogin() {
        
        /*Check Internet Connection */
        if !isNetworkReachable {
            self.showAlert(Alert(Texts.internetUnavailable, buttons: nil))
            return
        }
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleRegister() {
        
        startSpinner()
        
        /*Check Internet Connection */
        if !isNetworkReachable {
            self.stopSpinner()
            self.showAlert(Alert(Texts.internetUnavailable, buttons: nil))
            return
        }
        
        guard let name = nameTextField.text, let email = emailTextField.text, let mobileNumber = mobileNumberTextField.text, let profileImage = profileImageView.image, let password = passwordTextField.text else {
            return
        }
        
        if !validateRegistrationInputs() {
            return
        }
        
        FirebaseHandler.registerUser(with: name, email: email, mobileNumber: mobileNumber, password: password, profileImage: profileImage) { (user, error) in
            if error != nil {
                DLog("Error Creating User: \(String(describing: error))")
                return
            }
        
            DispatchQueue.main.async {
                self.stopSpinner()
                self.homeVC.fetchUserAndSetUpNavBar()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func clearTextFields() {
        self.nameTextField.text = nil
        self.emailTextField.text = nil
        self.mobileNumberTextField.text = nil
        self.passwordTextField.text = nil
        self.confirmPasswordTextField.text = nil
        self.profileImageView.image = #imageLiteral(resourceName: "profile_image")
    }
    
    func handleLogin() {
        dismissKeyboard()
        startSpinner()
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            DLog("Invalid Form!")
            self.stopSpinner()
            return
        }
        
        if !validateLoginInputs() {
            return
        }
        
        FirebaseHandler.loginUser(with: email, password: password) { (alert) in
            if alert != nil {
                self.stopSpinner()
                self.showAlert(alert!)
                return
            }
            
            DispatchQueue.main.async {
                self.stopSpinner()
                self.homeVC.fetchUserAndSetUpNavBar()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleLoginRegisterSegmentChange() {
        
        /* Change Register/Login Button Title */
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        /* Clear Text Fields*/
        clearTextFields()
        
        self.view.layoutIfNeeded()
        
        /* Change Layouts*/
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            
            //Login
            UIView.animate(withDuration: 0.6, animations: {
                
                self.nameTextField.placeholder = nil
                self.emailTextField.placeholder = nil
                self.mobileNumberTextField.placeholder = nil
                self.passwordTextField.placeholder = nil
                self.confirmPasswordTextField.placeholder = nil
                
                self.inputsContainerViewHeightAnchor?.isActive = false
                self.inputsContainerViewHeightAnchor? = self.inputsContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.149)
                self.inputsContainerViewHeightAnchor?.isActive = true
                
                self.nameTextFieldHeightAnchor?.isActive = false
                self.nameTextFieldHeightAnchor = self.nameTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 0)
                self.nameTextFieldHeightAnchor?.isActive = true
                
                self.emailTextFieldHeightAnchor?.isActive = false
                self.emailTextFieldHeightAnchor = self.emailTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/2)
                self.emailTextFieldHeightAnchor?.isActive = true
                
                self.mobileNumberTextFieldHeightAnchor?.isActive = false
                self.mobileNumberTextFieldHeightAnchor = self.mobileNumberTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 0)
                self.passwordTextFieldHeightAnchor?.isActive = true
                
                self.passwordTextFieldHeightAnchor?.isActive = false
                self.passwordTextFieldHeightAnchor = self.passwordTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/2)
                self.passwordTextFieldHeightAnchor?.isActive = true
                
                /* For Swift 3.0.Xcode 8.3 */
                self.passwordTextFieldTopAnchor?.isActive = false
                self.passwordTextFieldTopAnchor = self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor)
                self.passwordTextFieldTopAnchor?.isActive = true
                
                self.confirmPasswordTextFieldHeightAnchor?.isActive = false
                self.confirmPasswordTextFieldHeightAnchor = self.confirmPasswordTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 0)
                self.confirmPasswordTextFieldHeightAnchor?.isActive = true
                
                self.view.layoutIfNeeded()
                
                self.profileImageView.image = #imageLiteral(resourceName: "firebase_icon")
                self.profileImageView.layer.borderWidth = 0.0
                self.profileImageView.isUserInteractionEnabled = false
                
            }, completion: { (done) in
                self.emailTextField.placeholder = "Email Address"
                self.passwordTextField.placeholder = "Password"
            })
            
            resignFirstResponder()
        }
            
        else {
            
            //Registration
            UIView.animate(withDuration: 0.6, animations: {
                
                self.emailTextField.placeholder = nil
                self.passwordTextField.placeholder = nil
                
                self.inputsContainerViewHeightAnchor?.isActive = false
                self.inputsContainerViewHeightAnchor? = self.inputsContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.372)
                self.inputsContainerViewHeightAnchor?.isActive = true
                
                self.nameTextFieldHeightAnchor?.isActive = false
                self.nameTextFieldHeightAnchor = self.nameTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/5)
                self.nameTextFieldHeightAnchor?.isActive = true
                
                self.emailTextFieldHeightAnchor?.isActive = false
                self.emailTextFieldHeightAnchor = self.emailTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/5)
                self.emailTextFieldHeightAnchor?.isActive = true
            
                self.mobileNumberTextFieldHeightAnchor?.isActive = false
                self.mobileNumberTextFieldHeightAnchor = self.mobileNumberTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/5)
                self.mobileNumberTextFieldHeightAnchor?.isActive = true
                
                self.passwordTextFieldHeightAnchor?.isActive = false
                self.passwordTextFieldHeightAnchor = self.passwordTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/5)
                self.passwordTextFieldHeightAnchor?.isActive = true
                
                /* For Swift 3.0.Xcode 8.3 */
                self.passwordTextFieldTopAnchor?.isActive = false
                self.passwordTextFieldTopAnchor = self.passwordTextField.topAnchor.constraint(equalTo: self.mobileNumberTextField.bottomAnchor)
                self.passwordTextFieldTopAnchor?.isActive = true
                
                
                self.confirmPasswordTextFieldHeightAnchor?.isActive = false
                self.confirmPasswordTextFieldHeightAnchor = self.confirmPasswordTextField.heightAnchor.constraint(equalTo: self.inputsContainerView.heightAnchor, multiplier: 1/5)
                self.confirmPasswordTextFieldHeightAnchor?.isActive = true
                
                self.profileImageView.image = #imageLiteral(resourceName: "profile_image")
                self.profileImageView.layer.borderWidth = 2.0
                self.profileImageView.isUserInteractionEnabled = true
                
                self.updateViewConstraints()
                self.view.layoutIfNeeded()
                
            }, completion: { (done) in
                self.nameTextField.placeholder = "Name"
                self.emailTextField.placeholder = "Email Address"
                self.mobileNumberTextField.placeholder = "Mobile Number"
                self.passwordTextField.placeholder = "Password"
                self.confirmPasswordTextField.placeholder = "Confirm Password"
            })
            
            resignFirstResponder()
        }
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DLog(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage  = info[Keys.editedImageFromPicker] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[Keys.originalImageFromPicker] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            self.profileImageView.layer.borderColor = Theme.profileImageBorderColor
            self.profileImageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DLog("Cancelled Image Picker!")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Activity Indicator
    func startSpinner() {
        loginRegisterButton.setTitle("", for: .normal)
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        loginRegisterButton.setTitle(loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "Login" : "Register", for: .normal)
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    //MARK:- Handle Keyboard
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as! Double
        loginRegisterButtonBottomAnchor?.constant = -(keyboardFrame?.height)! - 12.0
        addTapRecognizer()
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as! Double
        loginRegisterButtonBottomAnchor?.constant = -24
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- UITextField Delegates
extension LoginViewController {
    
    /* Text Field Return Actions */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
            
        case emailTextField:
            if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
                passwordTextField.becomeFirstResponder()
            } else {
                mobileNumberTextField.becomeFirstResponder()
            }
            
        case mobileNumberTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
                handleLogin()
            } else {
                confirmPasswordTextField.becomeFirstResponder()
            }
            
        case confirmPasswordTextField:
            handleRegister()
            
        default:
            fatalError("Check for Extra TextFields.")
        }
        
        return true
    }
    
    /* Text Field Character Limit */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int
        
        switch textField {
        case nameTextField:
            maxLength = 20
            
        case passwordTextField:
            maxLength = 20
            
        case confirmPasswordTextField:
            maxLength = 20
            
        case mobileNumberTextField:
            maxLength = 10
        
        default:
            maxLength = 50
        }
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= maxLength
    }
}