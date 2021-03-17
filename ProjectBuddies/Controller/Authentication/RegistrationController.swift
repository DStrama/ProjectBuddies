//
//  RegisterController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "logo"))
        iv.contentMode = .scaleAspectFit
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
    
    private let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = K.Color.blue
        btn.setHeight(50)
        return btn
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regular!]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regularBold!]
        
        let attributedTitle = NSMutableAttributedString(string: "Have an acconut? ", attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: "Log in", attributes: boldAtts))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.backgroundColor = K.Color.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 160, width: 80)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    // MARK: - Actions
    
    @objc func handleShowLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
         guard let email = emailTextField.text else { return }
         guard let password = passwordTextField.text else { return }

        let credentials = AuthCredentials(email: email, password: password, fullname: "", profileImage: UIImage(named: "profileImage")!)
         AuthService.registerUser(withCredenctial: credentials) { error in
             if let error = error {
                 print("DEBUG: Failed to register user \(error.localizedDescription)")
                 return
             }
            self.delegate?.anthenticationDidComplete()
         }
     }
}
