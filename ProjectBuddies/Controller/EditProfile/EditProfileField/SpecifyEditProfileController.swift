//
//  SpecifyEditProfileController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 11/03/2021.
//

import UIKit
import MultilineTextField

protocol textDelegate: class {
    func saveText(controller: SpecifyEditProfileController)
}

class SpecifyEditProfileController: UIViewController {

    // MARK: - Properties
    
    var delegateSaveText: textDelegate?
    var propertyTitle: String?
    var typeOfOperation: String?
    var characterLimit = 0
    var height = 0
    var section: Int? = nil
    
    private lazy var editTextField: InputTextView = {
        var tv = InputTextView()
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var characterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    let textLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Join room"
        l.numberOfLines = 2
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    private let updateOrAddButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 48, bottom: 8, right: 48)
        btn.setHeight(40)
        return btn
    }()
    
    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
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
        updateOrAddButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.backgroundColor = K.Color.lighterCreme
        
        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)
        
        view.addSubview(editTextField)
        editTextField.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: CGFloat(height))
        
        view.addSubview(line)
        line.anchor(top: editTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: line.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        view.addSubview(updateOrAddButton)
        updateOrAddButton.anchor(top: characterCountLabel.bottomAnchor, paddingTop: 12)
        updateOrAddButton.centerX(inView: view)
    }
    
    
    private func setupNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        cancelBarButtonItem.tintColor = K.Color.navyApp

        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    func setUpProperties(title: String, text: String, type: String, placeholder: String){
        typeOfOperation = type
        let buttonTitle = type == "append" ? "Add" : "Update"
        updateOrAddButton.setTitle( buttonTitle, for: .normal)
        textLabel.text = title
        editTextField.text = text
        characterCountLabel.text = "\(text.count)/\(characterLimit)"
        editTextField.placeholderText = placeholder
        editTextField.placeholderLabel.isHidden = !editTextField.text.isEmpty
    }
    
    private func updateField() {
        guard let value = editTextField.text else { return }
        guard let title = propertyTitle else { return }
        
        showLoader(true)
        UserService.updateUser(field: title, value: value) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }
            
            self.delegateSaveText?.saveText(controller: self)
        }
    }
    
    private func appendField() {
        guard let value = editTextField.text else { return }
        guard let title = propertyTitle else { return }
        
        showLoader(true)
        UserService.appendFieldToUser(field: title, value: value) { error in
            self.showLoader(false)

            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }

            self.delegateSaveText?.saveText(controller: self)
        }
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    //MARK: - Actions
    
    @objc func doneTapped() {
        guard let operation = typeOfOperation else { return }
        if(operation == "update") {
            updateField()
        } else {
            appendField()
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SpecifyEditProfileController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: characterLimit)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/\(characterLimit)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && characterLimit != 300 {
            return false
        }
        return true
    }
}
