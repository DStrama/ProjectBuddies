//
//  ForgotPasswordController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 04/05/2021.
//

import UIKit

class ForgotPasswordController: UIViewController {

    // MARK: - Properties

    let textLabel: UILabel = {
        let l = UILabel()
        l.text = "Forgot passsword"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .left
        return l
    }()

    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "We will email you a code to reset your password."
        l.numberOfLines = 0
        l.font = K.Font.small
        l.textColor = K.Color.gray
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

    private let resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Reset", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.setHeight(50)
        return btn
    }()

    private let line: UIView = {
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

    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.white
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(ForgotPasswordController.textFieldDidChange(_:)), for: .editingChanged)

        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24)

        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)

        view.addSubview(emailTextField)
        emailTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24, height: 40)

        view.addSubview(line)
        line.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 1)

        view.addSubview(resetButton)
        resetButton.anchor(top: line.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
    }

    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    // MARK: - Actions

    @objc private func resetTapped() {
        UserService.sendPasswordResetEmail(email: emailTextField.text!)
        
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if isValidEmail(textField.text!) {
            self.resetButton.isEnabled = true
            self.resetButton.alpha = 1.0
        } else {
            self.resetButton.isEnabled = false
            self.resetButton.alpha = 0.5
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
