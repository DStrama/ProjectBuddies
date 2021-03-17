//
//  LoginController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit

protocol AuthenticationDelegate: class {
    func anthenticationDidComplete()
}

class LoginController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "logo"))
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email", txtColor: K.Color.black, bgColor: K.Color.lightBlack)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password", txtColor: K.Color.black, bgColor: K.Color.lightBlack)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = K.Color.blue
        btn.setHeight(50)
        return btn
    }()
    
    private let forgotPassword: UIButton = {
        let btn = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regular!]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regularBold!]
        
        let attributedTitle = NSMutableAttributedString(string: "Forgot your password? ", attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: "Get help signing in.", attributes: boldAtts))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        return btn
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regular!]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regularBold!]
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an acconut? ", attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: boldAtts))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    
    private let registrationProblem: UITextField = {
        let tf = UITextField()
        return tf
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        loginButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        view.backgroundColor = K.Color.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 160, width: 80)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPassword])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    // MARK: - Actions
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logUserIn(email: email, password: password) { (result, error)  in
            if let error = error {
                print("DEBUG: Failed to log in user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.anthenticationDidComplete()
        }
     }
}
