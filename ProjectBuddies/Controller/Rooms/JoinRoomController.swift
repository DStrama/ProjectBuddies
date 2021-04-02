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
    
    private lazy var keyTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter code.."
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
        
        view.backgroundColor = K.Color.lighterCreme

        view.addSubview(keyTextField)
        keyTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: keyTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 12)
    }
    
    private func setupNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinTapped))
        navigationItem.title = "Join room"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
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
