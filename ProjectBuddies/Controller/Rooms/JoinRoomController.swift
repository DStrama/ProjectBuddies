//
//  JoinRoomController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 17/03/2021.
//

import UIKit

class JoinRoomController: UIViewController {
    
    // MARK: - Properties
    
    private var keyLabel: CustomLabel = {
        var l = CustomLabel(context: "Key", fontType: K.Font.regular!)
        return l
    }()
    
    private var keyTextField: UITextField = {
        var tf = CustomTextField(placeholder: "Ex: 2183gebf122e", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
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
        
        view.addSubview(keyLabel)
        keyLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(keyTextField)
        keyTextField.anchor(top: keyLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    private func setupNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinTapped))
        navigationItem.title = "Join room"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc func joinTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
