//
//  RegisterController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

protocol AuthenticationDelegate: AnyObject {
    func anthenticationDidComplete()
}

class RegistrationController: UIViewController, UIPageViewControllerDelegate {
    // MARK: - Properties

    weak var delegate: AuthenticationDelegate?

    private let googleButton = GIDSignInButton()

    private let facebookButton = FBLoginButton()

    let signupLabel: UILabel = {
        let l = UILabel()
        l.text = "Sign up for ProjectBuddies"
        l.font = K.Font.extraLargeBold
        l.textAlignment = .center
        return l
    }()

    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Create profile and find people for\nlabolatory project classes."
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

    private let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.black, .font: K.Font.regular!]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.red, .font: K.Font.regularBold!]

        let attributedTitle = NSMutableAttributedString(string: "Already have an acconut? ", attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: "Log in", attributes: boldAtts))

        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        btn.setHeight(80)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // Google Authentication
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Facebook Authentication
        facebookButton.delegate = self

    }

    // MARK: - Helpers

    private func configureUI() {
        emailButton.addTarget(self, action: #selector(handleEmailSignup), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(handleGoogleSingup), for: .touchUpInside)

        view.backgroundColor = K.Color.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(signupLabel)
        signupLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingRight: 24)

        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: signupLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingRight: 24)

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

    @objc func handleShowLogin() {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    // Email Sign Up

    @objc func handleEmailSignup() {
        let controller = SignupEmailController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    // Google Sign Up

    @objc func handleGoogleSingup() {
        GIDSignIn.sharedInstance().signIn()
    }

}

extension RegistrationController: SignupEmailControllerDelegate {
    func didFinishSignup() {
        self.delegate?.anthenticationDidComplete()
    }
}

extension RegistrationController: LoginControllerDelegate {
    func didFinishLogin() {
        self.delegate?.anthenticationDidComplete()
    }
}

// MARK: - Facebook Authentication

extension RegistrationController: LoginButtonDelegate {

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard var token = result?.token?.tokenString else {
            print("Error with Facebook authentication")
            return
        }

        let request = FBSDKLoginKit.GraphRequest(graphPath: "")

    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {

    }

}
