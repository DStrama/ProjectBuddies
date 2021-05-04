//
//  EditProfileProjectTechnologiesController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 23/04/2021.
//

import UIKit

protocol EditProfileProjectTechnologiesDelegate: class {
    func continueNextPage(controller: EditProfileProjectTechnologiesController)
}

class EditProfileProjectTechnologiesController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileProjectTechnologiesDelegate?
    
    let fistNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "My project\ntechnologies"
        l.numberOfLines = 2
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    lazy var keyTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter names..."
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Create", for: .normal)
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
    
    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
        return v
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
        
        view.addSubview(line)
        line.anchor(top: keyTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: line.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        view.addSubview(continueButton)
        continueButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 48)
        continueButton.centerX(inView: view)
        
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

// MARK: - UITextFieldDelegate

extension EditProfileProjectTechnologiesController: UITextViewDelegate {
    
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

