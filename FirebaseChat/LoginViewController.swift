//
//  LoginViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {
    
    //MARK:- Properties
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firebase_icon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        return imageView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginRegisterSegmentChange), for: .valueChanged)
        return sc
    }()
    
    let spinner: UIActivityIndicatorView = {
       let spin = UIActivityIndicatorView()
        spin.activityIndicatorViewStyle = .white
        spin.hidesWhenStopped = true
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    var homeVC = HomeViewController()
    var profileImageAdded = false
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        setUpInputContainerView()
        setUpLoginRegisterButton()
        setUpLoginRegisterSegmentedControl()
        setUpProfileImageView()
    }

    //MARK:- Set Up Methods
    private func setUpInputContainerView() {
        
        /* Container View */
        view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        /* Name TextField */
        inputsContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        /* Email TextField */
        inputsContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
      
        /* Password TextField */
        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        /* Name Separator */
        inputsContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        /* Email Separator */
        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setUpLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginRegisterButton.titleLabel?.text = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "Login" : "Register"
        
        /* Spinner */
        loginRegisterButton.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: loginRegisterButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loginRegisterButton.centerYAnchor).isActive = true
        stopSpinner()
    }
    
    private func setUpProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setUpLoginRegisterSegmentedControl() {
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

//MARK:- Handlers
extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleRegisterLogin() {
        startSpinner()
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            DLog("Invalid Form!")
            self.stopSpinner()
            self.showAlert(Alert(title: "Required fields are empty!", message: "Please retry", buttons: nil, textBoxes: nil))
            return
        }
        
        if !profileImageAdded {
            self.stopSpinner()
            self.showAlert(Alert(title: "Please add your Profile Image!", message: "", buttons: nil, textBoxes: nil))
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                DLog("Error: \(String(describing: error))")
                self.stopSpinner()
                self.showAlert(Alert(title: "Failed to Sign Up!", message: "Please retry", buttons: nil, textBoxes: nil))
                return
            }
            
            guard let uid = user?.uid else {
                self.stopSpinner()
                return
            }
            
            //If Success Signing Up, Add profile Image
            let storageRef = Storage.storage().reference().child(Keys.profileImages).child("\(uid).jpg")
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage.reducedSize(), 0.8) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        DLog(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = [Keys.name: name, Keys.email: email, Keys.profileImageUrl: profileImageUrl] as [String : Any]
                        self.registerUserIntoDatabase(with: uid, values: values)
                    }
                })
            }
        }
    }
    
    private func registerUserIntoDatabase(with uid: String, values: [String: Any]) {
        
        let ref = Database.database().reference()
        let usersRef = ref.child(Keys.users).child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                DLog(err!)
                self.stopSpinner()
                self.showAlert(Alert(title: "Failed to Sign Up!", message: "Please retry", buttons: nil, textBoxes: nil))
                return
            }
            
            DLog("Saved User Successfully into Firebase DB!")
            let user = User()
            user.setValuesForKeys(values)
            self.homeVC.setUpNavBar(with: user)
            self.stopSpinner()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            DLog("Invalid Form!")
            self.stopSpinner()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                DLog("Error: \(String(describing: error?.localizedDescription))")
                self.stopSpinner()
                self.showAlert(Alert(title: "Wrong Email or Password!", message: "Please retry", buttons: nil, textBoxes: nil))
                return
            }
            
            self.homeVC.fetchUserAndSetUpNavBar()
            self.stopSpinner()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleLoginRegisterSegmentChange() {
        
        /* Change Register/Login Button Title */
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        /* Change Layouts*/
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            inputsContainerViewHeightAnchor?.constant = 100
            nameTextFieldHeightAnchor?.isActive = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
            nameTextFieldHeightAnchor?.isActive = true
            emailTextFieldHeightAnchor?.isActive = false
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            emailTextFieldHeightAnchor?.isActive = true
            passwordTextFieldHeightAnchor?.isActive = false
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            passwordTextFieldHeightAnchor?.isActive = true
        }
        
        else {
            inputsContainerViewHeightAnchor?.constant = 150
            nameTextFieldHeightAnchor?.isActive = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            nameTextFieldHeightAnchor?.isActive = true
            emailTextFieldHeightAnchor?.isActive = false
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAnchor?.isActive = true
            passwordTextFieldHeightAnchor?.isActive = false
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            passwordTextFieldHeightAnchor?.isActive = true
        }
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DLog(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage  = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            self.profileImageView.layer.borderWidth = 2.0
            self.profileImageView.layer.borderColor = Theme.profileImageBorderColor
            self.profileImageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DLog("Cancelled Image Picker!")
        dismiss(animated: true, completion: nil)
    }
    
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
}
