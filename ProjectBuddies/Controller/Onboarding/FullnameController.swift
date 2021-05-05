//
//  FullnameView.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/04/2021.
//

import UIKit

protocol FullnameContinueDelegate: class {
    func continueNextPage(controller: FullnameController)
}

class FullnameController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: FullnameContinueDelegate?
    
    let fistNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "My full \nname is"
        l.numberOfLines = 2
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    lazy var keyTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter name.."
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Continue", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 48, bottom: 8, right: 48)
        btn.setHeight(40)
        return btn
    }()
    
    private var characterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsAndConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Helpers

    private func setUpViewsAndConstraints() {
        characterCountLabel.text = "0/35"
        continueButton.addTarget(self, action: #selector(continueOnBoarding), for: .touchUpInside)
        view.backgroundColor = K.Color.lighterCreme
        
        view.addSubview(fistNameLabel)
        fistNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)

        view.addSubview(keyTextField)
        keyTextField.anchor(top: fistNameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: keyTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        view.addSubview(continueButton)
        continueButton.centerX(inView: view)
        continueButton.anchor(top: characterCountLabel.bottomAnchor, paddingTop: 32)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    @objc private func continueOnBoarding() {
        self.delegate!.continueNextPage(controller: self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension FullnameController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: 35)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/35"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}
