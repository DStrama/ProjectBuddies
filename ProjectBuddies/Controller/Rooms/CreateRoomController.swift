//
//  RoomController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 15/03/2021.
//

import UIKit

protocol CreateRoomDelegate: class {
    func controllerDidFinishUploadingRoom(controller: CreateRoomController)
}

class CreateRoomController: UIViewController {

    // MARK: - Properties
    
    weak var delegate: CreateRoomDelegate?
    
    private var roomImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "group"))
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = K.Color.searchBarGray
        iv.clipsToBounds = true
        iv.setDimensions(height: 80, width: 80)
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 34
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        return iv
    }()
    
    let editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Upload", for: .normal)
        btn.setTitleColor(K.Color.black, for: .normal)
        return btn
    }()
    
    
    private var titleLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Room name"
        return l
    }()
    
    private lazy var titleTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter name.."
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
    
    private var createButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Create", for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpViewsAndConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(doneTapped))
        navigationItem.title = "Create room"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setUpViewsAndConstraints() {
        characterCountLabel.text = "0/35"
        
        editButton.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        view.backgroundColor = K.Color.lighterCreme
        view.isUserInteractionEnabled = true
        
        view.addSubview(roomImage)
        roomImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        roomImage.centerX(inView: view)
        
        view.addSubview(editButton)
        editButton.centerX(inView: roomImage)
        editButton.anchor(top: roomImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingBottom: 8)

        view.addSubview(titleLabel)
        titleLabel.anchor(top: editButton.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(titleTextField)
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: titleTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 12)
        
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    // MARK: - Actions
    
    @objc func doneTapped() {
        guard let name = titleTextField.text, !name.isEmpty else { return }
        guard let image = roomImage.image else { return }
        
        showLoader(true)
        RoomService.uploadRoom(name: name, image: image) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingRoom(controller: self)
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editImage() {
        showImagePickerControllerActionSheet()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreateRoomController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction,cameraAction,cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let oryginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            roomImage.image = oryginalImage
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            roomImage.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension CreateRoomController: UITextViewDelegate {
    
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

