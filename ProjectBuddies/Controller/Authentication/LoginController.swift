//
//  LoginController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit

protocol LoginControllerDelegate: AnyObject {
    func didFinishLogin()
}

class LoginController: UIViewController {
    // MARK: - Properties

    weak var delegate: LoginControllerDelegate?

    let loginLabel: UILabel = {
        let l = UILabel()
        l.text = "Log in to ProjectBuddies"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .center
        return l
    }()

    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Manage your account, create room,\nfind group or members to your group."
        l.numberOfLines = 0
        l.font = K.Font.regular
        l.textColor = K.Color.gray
        l.textAlignment = .center
        return l
    }()

    private let emailButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Use email / phone", for: .normal)
        btn.titleLabel?.font = K.Font.smallBold
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = K.Color.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = K.Color.lightGray.cgColor
        let icon = UIImage(systemName: "person")
        btn.tintColor = K.Color.black
        btn.setImage(icon, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -150, bottom: 0, right: 0)
        btn.setHeight(50)
        return btn
    }()

    private let facebookButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue with Facebook", for: .normal)
        btn.titleLabel?.font = K.Font.smallBold
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = K.Color.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = K.Color.lightGray.cgColor
        btn.setHeight(50)
        return btn
    }()

    private let appleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue with Apple", for: .normal)
        btn.titleLabel?.font = K.Font.smallBold
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = K.Color.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = K.Color.black.cgColor
        let icon = UIImage(systemName: "applelogo")
        btn.tintColor = K.Color.black
        btn.setImage(icon, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -150, bottom: 0, right: 0)
        btn.setHeight(50)
        return btn
    }()

    private let googleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue with Google", for: .normal)
        btn.titleLabel?.font = K.Font.smallBold
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = K.Color.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = K.Color.lightGray.cgColor
        btn.setHeight(50)
        return btn
    }()

    private let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)

        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regular!]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.red, .font: K.Font.regularBold!]

        let attributedTitle = NSMutableAttributedString(string: "Don't have an acconut? ", attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: boldAtts))

        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        btn.setHeight(80)
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
        emailButton.addTarget(self, action: #selector(handleEmailLogin), for: .touchUpInside)

        view.backgroundColor = K.Color.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(loginLabel)
        loginLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingRight: 24)

        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: loginLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingRight: 24)

        let stack = UIStackView(arrangedSubviews: [emailButton, facebookButton, appleButton, googleButton])
        stack.axis = .vertical
        stack.spacing = 10

        view.addSubview(stack)
        stack.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)

        dontHaveAccountButton.backgroundColor = K.Color.veryLightGray
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

    }

    // MARK: - Actions

    @objc func handleShowSignUp() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func handleEmailLogin() {
        let controller = LoginWithEmailController()
        controller.delegateFinish = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

}

extension LoginController: LoginWithEmailControllerDelegate {
    func didFinishLogin() {
        self.delegate?.didFinishLogin()
    }
}
