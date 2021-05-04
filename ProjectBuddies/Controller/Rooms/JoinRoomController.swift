//
//  JoinRoomController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 17/03/2021.
//

import UIKit

protocol JoinRoomDelegate: class {
    func controllerDidFinishUploadingRoom(controller: JoinRoomController)
}

class JoinRoomController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: JoinRoomDelegate?
    
    let textLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Join room"
        l.numberOfLines = 2
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    private lazy var keyTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter code..."
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = .white
        return tv
    }()
    
    private var characterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private let joinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Join", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 68, bottom: 8, right: 68)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints() {
        characterCountLabel.text = "0/20"
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        
        view.backgroundColor = K.Color.lighterCreme
        
        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)

        view.addSubview(keyTextField)
        keyTextField.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 56, paddingRight: 56, height: 40)
        
        view.addSubview(line)
        line.anchor(top: keyTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 56, paddingRight: 56, height: 2)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: line.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 56, height: 18)
        
        view.addSubview(joinButton)
        joinButton.centerX(inView: view)
        joinButton.anchor(top: characterCountLabel.bottomAnchor, paddingTop: 32)
        
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    // MARK: - Actions
    
    @objc func joinTapped() {
        guard let key = keyTextField.text, !key.isEmpty else { return }

        showLoader(true)
        RoomService.joinRoom(key: key) { error in
            self.showLoader(false)

            if let error = error {
                print("Error adding into room: \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingRoom(controller: self)
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension JoinRoomController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: 20)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/20"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}
