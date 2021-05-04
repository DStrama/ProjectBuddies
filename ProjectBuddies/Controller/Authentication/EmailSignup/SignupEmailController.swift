//
//  SignupEmailController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/05/2021.
//

import UIKit

protocol SignupEmailControllerDelegate: AnyObject {
    func didFinishSignup()
}

class SignupEmailController: UIViewController {

    // MARK: - Properties

    weak var delegate: SignupEmailControllerDelegate?

    let textLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Enter email address"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .left
        return l
    }()

    lazy var emailTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Email address"
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = .white
        return tv
    }()

    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.gray
        return v
    }()

    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.setHeight(50)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsAndConstraints()
        setupNavigationBar()
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
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24)

        view.addSubview(emailTextField)
        emailTextField.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 24, paddingRight: 24, height: 40)

        view.addSubview(line)
        line.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 1)

        view.addSubview(nextButton)
        nextButton.anchor(top: line.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
    }

    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }

    // MARK: - Actions

    @objc func dismissTapped() {
        dismiss(animated: false, completion: nil)
    }

    @objc func nextTapped() {
        let controller = SignupPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension SignupEmailController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: 35)
        if isValidEmail(textView.text) {
            self.nextButton.isEnabled = true
            self.nextButton.alpha = 1.0
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = 0.5
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}

extension SignupEmailController: SignupPasswordControllerDelegate {
    func didFinishSignup() {
        self.delegate?.didFinishSignup()
    }
}
