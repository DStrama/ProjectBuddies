//
//  UpdateEditProfileProjectController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/06/2021.
//

import Foundation
import UIKit

protocol UpdateProjectEditDelegate: AnyObject {
    func updateProjectEdit(controller: UpdateEditProfileProjectController)
}

class UpdateEditProfileProjectController: UIViewController {
    
    //MARK: - Properties
    
    var documentId: String = String()
    var experienceEditDelegate: ExprienceEditDelegate?
    var delegate: UpdateProjectEditDelegate?
    
    // name
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Name"
        l.numberOfLines = 0
        l.font = K.Font.largeBold
        l.textAlignment = .left
        return l
    }()
    
    lazy var nameTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Update project name..."
        tv.placeholderLabel.isHidden = true
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var nameCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let nameLine: UIView = {
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

    // technologies
    
    let technologiesLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Technologies"
        l.numberOfLines = 0
        l.font = K.Font.largeBold
        l.textAlignment = .left
        return l
    }()
    
    lazy var technologiesTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Update technologies..."
        tv.placeholderLabel.isHidden = true
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var technologiesCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let technologiesLine: UIView = {
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
        
        nameCharacterCountLabel.text = "\(nameTextField.text.count)/35"
        technologiesCharacterCountLabel.text = "\(technologiesTextField.text.count)/35"
        descriptionCharacterCountLabel.text = "\(descriptionTextField.text.count)/300"
        

        // position
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 56)

        view.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(nameLine)
        nameLine.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(nameCharacterCountLabel)
        nameCharacterCountLabel.anchor(top: nameLine.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        // company
        
        view.addSubview(technologiesLabel)
        technologiesLabel.anchor(top: nameCharacterCountLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 56)
        
        view.addSubview(technologiesTextField)
        technologiesTextField.anchor(top: technologiesLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(technologiesLine)
        technologiesLine.anchor(top: technologiesTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(technologiesCharacterCountLabel)
        technologiesCharacterCountLabel.anchor(top: technologiesLine.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        // description
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: technologiesCharacterCountLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 56)
        
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
    
    func setUpProperties(name: String, description: String, technologies: String) {
        nameTextField.text = name
        descriptionTextField.text = description
        technologiesTextField.text = technologies
    }
    
    // MARK: - Actions
    
    @objc func updateTapped() {
        guard let name = nameTextField.text else { return }
        guard let technologies = technologiesTextField.text  else { return }
        guard let description = descriptionTextField.text else { return }
        
        showLoader(true)
        ProjectService.updateProject(id: documentId , title: name, description: description, technologies: technologies) { error in
            self.showLoader(false)
            if let error = error {
                print("Error adding experience: \(error.localizedDescription)")
                return
            }
            self.delegate?.updateProjectEdit(controller: self)
        }
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension UpdateEditProfileProjectController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == nameTextField {
            checkMaxLength(textView, maxLength: 35)
            let count = textView.text.count
            nameCharacterCountLabel.text = "\(count)/35"
        } else if textView == technologiesTextField {
            
        } else if textView == descriptionTextField {
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}
