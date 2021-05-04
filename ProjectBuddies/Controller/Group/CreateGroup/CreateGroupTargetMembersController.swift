//
//  CreateGroupTargetMeembersController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 21/04/2021.
//

import UIKit

protocol CreateGroupTargetMembersDelegate: class {
    func continueNextPage(controller: CreateGroupTargetMembersController)
}

class CreateGroupTargetMembersController: UIViewController {
    
    // MARK: - Properties
    var roomId: String = ""
    
    var targetNumber = 0
    
    let numbers = Array(2...20)
    
    weak var delegate: CreateGroupTargetMembersDelegate?
    
    let targetMembersLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Target number\nof people in group"
        l.numberOfLines = 3
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    private let picker: UIPickerView = {
        let p = UIPickerView()
        return p
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
    
    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = K.Color.navyApp
        return v
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsAndConstraints()
        setupPicker()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Helpers

    private func setUpViewsAndConstraints() {
        characterCountLabel.text = "0/3"
        continueButton.addTarget(self, action: #selector(continueOnBoarding), for: .touchUpInside)
        view.backgroundColor = K.Color.lighterCreme
        
        view.addSubview(targetMembersLabel)
        targetMembersLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)

        view.addSubview(picker)
        picker.anchor(top: targetMembersLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56)
        
        view.addSubview(continueButton)
        continueButton.centerX(inView: view)
        continueButton.anchor(top: picker.bottomAnchor, paddingTop: 32)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    private func setupPicker() {
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = K.Color.white
    }
    
    @objc private func continueOnBoarding() {
        self.delegate!.continueNextPage(controller: self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UIPickerViewDataSource

extension CreateGroupTargetMembersController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }

}

extension CreateGroupTargetMembersController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        targetNumber = numbers[row]
    }
}

