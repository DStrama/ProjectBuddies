//
//  LoginWithEmailController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/05/2021.
//

import UIKit

protocol LoginWithEmailControllerDelegate: AnyObject {
    func didFinishLogin()
}

class LoginWithEmailController: UIViewController, UITextViewDelegate {

    // MARK: - Properties

    weak var delegateFinish: LoginWithEmailControllerDelegate?

    private let loginLabel: UILabel = {
        let l = UILabel()
        l.text = "Log in to ProjectBuddies"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .left
        return l
    }()

    private lazy var emailTextField: TextField = {
        var tv = TextField()
        tv.placeholder = "Email address"
        tv.font = K.Font.regular
        tv.backgroundColor = .white
        return tv
    }()

    private lazy var passwordTextField: TextField = {
        var tv = TextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.font = K.Font.regular
        tv.backgroundColor = .white
        return tv
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.setHeight(50)
        return btn
    }()

    private let forgotButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot password?", for: .normal)
        btn.titleLabel?.font = K.Font.smallBold
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.setHeight(50)
        return btn
    }()

    private let lineOne: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.gray
        return v
    }()

    private let lineTwo: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.gray
        return v
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpViewsAndConstraints()
    }

    // MARK: - Helpers

    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.white
        passwordTextField.addTarget(self, action: #selector(SignupPasswordController.textFieldDidChange(_:)), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)

        view.addSubview(loginLabel)
        loginLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24)

        view.addSubview(emailTextField)
        emailTextField.anchor(top: loginLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24, height: 40)

        view.addSubview(lineOne)
        lineOne.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 1)

        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: lineOne.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingRight: 24, height: 40)

        view.addSubview(lineTwo)
        lineTwo.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 1)

        view.addSubview(forgotButton)
        forgotButton.anchor(top: lineTwo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingRight: 24)

        view.addSubview(loginButton)
        loginButton.anchor(top: forgotButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
    }

    private func checkMaxLength(_ textView: UITextField, maxLength: Int) {
        if (textView.text!.count) > maxLength {
            textView.deleteBackward()
        }
    }

    // MARK: - Actions

    @objc private func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func loginTapped() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        showLoader(true)
        AuthService.logUserIn(email: email, password: password) { (result, error) in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to log in user \(error.localizedDescription)")
                return
            }

            self.delegateFinish?.didFinishLogin()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let passwordText = textField.text, !passwordText.isEmpty else { return }
        guard let emailText = emailTextField.text, !emailText.isEmpty else { return }

//        checkMaxLength(textField, maxLength: 20)
//        if isValidPassword(passwordText) && isValidEmail(emailText) {
//            self.loginButton.isEnabled = true
//            self.loginButton.alpha = 1.0
//        } else {
//            self.loginButton.isEnabled = false
//            self.loginButton.alpha = 0.5
//        }
        
        self.loginButton.isEnabled = true
        self.loginButton.alpha = 1.0
    }

    @objc private func forgotPasswordTapped() {
        let controller = ForgotPasswordController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

}
