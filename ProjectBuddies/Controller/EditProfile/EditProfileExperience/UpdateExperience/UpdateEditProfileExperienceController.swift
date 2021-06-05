//
//  UpdateProfileExperienceController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/06/2021.
//

import Foundation
import UIKit

protocol UpdateExprienceEditDelegate: AnyObject {
    func updateExperienceEdit(controller: UpdateEditProfileExperienceController)
}

class UpdateEditProfileExperienceController: UIViewController {
    
    //MARK: - Properties
    
    var documentId: String = String()
    var experienceEditDelegate: ExprienceEditDelegate?
    var delegate: UpdateExprienceEditDelegate?
    
    // position
    
    let positionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Position"
        l.numberOfLines = 0
        l.font = K.Font.largeBold
        l.textAlignment = .left
        return l
    }()
    
    lazy var positionTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Update position name..."
        tv.placeholderLabel.isHidden = true
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var positionCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let positionLine: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
        return v
    }()
    
    // company
    
    let companyLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Company"
        l.numberOfLines = 0
        l.font = K.Font.largeBold
        l.textAlignment = .left
        return l
    }()
    
    lazy var companyTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Update company name..."
        tv.placeholderLabel.isHidden = true
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var companyCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let companyLine: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
        return v
    }()

    // description
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Description"
        l.numberOfLines = 0
        l.font = K.Font.largeBold
        l.textAlignment = .left
        return l
    }()
    
    lazy var descriptionTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Update description..."
        tv.placeholderLabel.isHidden = true
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var descriptionCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let descriptionLine: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
        return v
    }()
    
    private let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Update", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 48, bottom: 8, right: 48)
        btn.setHeight(40)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsAndConstraints()
        setupNavigationBar()
    }
    
    //MARK: - Helpers
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.lighterCreme
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        
        positionCharacterCountLabel.text = "\(positionTextField.text.count)/35"
        companyCharacterCountLabel.text = "\(companyTextField.text.count)/35"
        descriptionCharacterCountLabel.text = "\(descriptionTextField.text.count)/300"
        

        // position
        
        view.addSubview(positionLabel)
        positionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 56)

        view.addSubview(positionTextField)
        positionTextField.anchor(top: positionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(positionLine)
        positionLine.anchor(top: positionTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(positionCharacterCountLabel)
        positionCharacterCountLabel.anchor(top: positionLine.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        // company
        
        view.addSubview(companyLabel)
        companyLabel.anchor(top: positionCharacterCountLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 56)
        
        view.addSubview(companyTextField)
        companyTextField.anchor(top: companyLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(companyLine)
        companyLine.anchor(top: companyTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(companyCharacterCountLabel)
        companyCharacterCountLabel.anchor(top: companyLine.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        // description
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: companyCharacterCountLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 56)
        
        view.addSubview(descriptionTextField)
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 120)
        
        view.addSubview(descriptionLine)
        descriptionLine.anchor(top: descriptionTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(descriptionCharacterCountLabel)
        descriptionCharacterCountLabel.anchor(top: descriptionLine.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        // button
        
        view.addSubview(updateButton)
        updateButton.centerX(inView: view)
        updateButton.anchor(top: descriptionCharacterCountLabel.bottomAnchor, paddingTop: 32)
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    func setUpProperties(title: String, company: String, description: String) {
        positionTextField.text = title
        companyTextField.text = company
        descriptionTextField.text = description
    }
    
    // MARK: - Actions
    
    @objc func updateTapped() {
        guard let title = positionTextField.text else { return }
        guard let company = companyTextField.text  else { return }
        guard let description = descriptionTextField.text else { return }
        
        showLoader(true)
        ExperienceService.updateExperience(id: documentId , title: title, company: company, description: description) { error in
            self.showLoader(false)
            if let error = error {
                print("Error adding experience: \(error.localizedDescription)")
                return
            }
            self.delegate?.updateExperienceEdit(controller: self)
        }
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension UpdateEditProfileExperienceController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == positionTextField {
            checkMaxLength(textView, maxLength: 35)
            let count = textView.text.count
            positionCharacterCountLabel.text = "\(count)/35"
        } else if textView == companyTextField {
            checkMaxLength(textView, maxLength: 35)
            let count = textView.text.count
            companyCharacterCountLabel.text = "\(count)/35"
        } else if textView == descriptionTextField {
            checkMaxLength(textView, maxLength: 300)
            let count = textView.text.count
            descriptionCharacterCountLabel.text = "\(count)/300"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}
