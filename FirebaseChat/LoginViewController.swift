//
//  LoginViewController.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    //MARK:- Outlets
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.loginRegisterViewBGColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Theme.loginRegisterButtonBGColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(Theme.buttonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.delegate = self
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var mobileNumberTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.keyboardType = .phonePad
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.delegate = self
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "firebase_icon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = Theme.profileImageBorderColor
        imageView.layer.borderWidth = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
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
    
    //MARK:- Properties
    var user: User?
    var homeVC = HomeViewController()
    var profileImageAdded = false
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var mobileNumberTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldTopAnchor: NSLayoutConstraint? //For Swift 3.0, Xcode 8.3
    var confirmPasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var loginRegisterButtonBottomAnchor: NSLayoutConstraint?
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.loginRegisterSceneBGColor
        
        setUpLoginRegisterButton()
        setUpInputContainerView()
        setUpLoginRegisterSegmentedControl()
        setUpProfileImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Set Up Methods
    private func setUpLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButtonBottomAnchor = loginRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        loginRegisterButtonBottomAnchor?.isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginRegisterButton.titleLabel?.text = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "Login" : "Register"
        
        /* Spinner */
        loginRegisterButton.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: loginRegisterButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loginRegisterButton.centerYAnchor).isActive = true
        stopSpinner()
    }
    
    private func setUpInputContainerView() {
        
        /* Container View */
        self.view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainerView.bottomAnchor.constraint(equalTo: loginRegisterButton.topAnchor, constant: -12).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0.149: 0.529)
        inputsContainerViewHeightAnchor?.isActive = true
        
        /* First Name TextField */
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/7)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        /* Email TextField */
        inputsContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/7)
        emailTextFieldHeightAnchor?.isActive = true

        
        /* Mobile Number TextField */
        inputsContainerView.addSubview(mobileNumberTextField)
        mobileNumberTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        mobileNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        mobileNumberTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        mobileNumberTextFieldHeightAnchor = mobileNumberTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/7)
        mobileNumberTextFieldHeightAnchor?.isActive = true
        
        /* Password TextField */
        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextFieldTopAnchor = passwordTextField.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor)
        passwordTextFieldTopAnchor?.isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/7)
        passwordTextFieldHeightAnchor?.isActive = true
        
        /* Confirm Password TextField */
        inputsContainerView.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmPasswordTextFieldHeightAnchor = confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/7)
        confirmPasswordTextFieldHeightAnchor?.isActive = true
    }
    
    func setUpLoginRegisterSegmentedControl() {
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setUpProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -16).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.135).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.135).isActive = true
    }
    
    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
}
