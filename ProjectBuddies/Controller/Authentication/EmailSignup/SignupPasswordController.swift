//
//  SignupPasswordController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/05/2021.
//

import UIKit

protocol SignupPasswordControllerDelegate: AnyObject {
    func didFinishSignup()
}

class SignupPasswordController: UIViewController {

    // MARK: - Properties

    weak var delegate: SignupPasswordControllerDelegate?

    let textLabel: UILabel = {
        let l = UILabel()
        l.text = "Create password"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .left
        return l
    }()

    lazy var passwordTextField: TextField = {
        var tv = TextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.font = K.Font.regular
        tv.backgroundColor = .white
        return tv
    }()

    var email: String? = nil

    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.gray
        return v
    }()

    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.setHeight(50)
        return btn
    }()

    let textPasswordLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Your password must have:\n-8 to 20 characters\n-Letters, numbers, and special characters"
        l.numberOfLines = 0
        l.font = K.Font.small
        l.textColor = K.Color.gray
        l.textAlignment = .left
        return l
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
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dismissTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.white
        passwordTextField.addTarget(self, action: #selector(SignupPasswordController.textFieldDidChange(_:)), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24)

        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24, height: 40)

        view.addSubview(line)
        line.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 1)

        view.addSubview(textPasswordLabel)
        textPasswordLabel.anchor(top: line.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)

        view.addSubview(nextButton)
        nextButton.anchor(top: textPasswordLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
    }

    private func checkMaxLength(_ textView: UITextField, maxLength: Int) {
        if (textView.text!.count) > maxLength {
            textView.deleteBackward()
        }
    }

    // MARK: - Actions

    @objc func dismissTapped() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func nextTapped() {
        guard let email = self.email else { return }
        guard let password = self.passwordTextField.text else { return }
        
        showLoader(true)
        let credentials = AuthCredentials(email: email, password: password, fullname: "", profileImage: UIImage(named: "profileImage")!)
        AuthService.registerUser(withCredenctial: credentials) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            self.delegate?.didFinishSignup()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        checkMaxLength(textField, maxLength: 20)

        if isValidPassword(textField.text!) {
            self.nextButton.isEnabled = true
            self.nextButton.alpha = 1.0
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = 0.5
        }
    }
}
