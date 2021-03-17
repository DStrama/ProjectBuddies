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
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 80, width: 80)
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    let editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Change photo", for: .normal)
        btn.setTitleColor(K.Color.black, for: .normal)
        return btn
    }()
    
    
    private var titleLabel: CustomLabel = {
        var l = CustomLabel(context: "Title", fontType: K.Font.regular!)
        return l
    }()
    
    private var titleTextField: UITextField = {
        var tf = CustomTextField(placeholder: "Ex: CS50 lab", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
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
    }
    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        navigationItem.title = "Create room"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    private func setUpViewsAndConstraints() {
        editButton.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        view.backgroundColor = K.Color.white
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
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
    }
    
    // MARK: - Actions
    
    @objc func doneTapped() {
        guard let name = titleTextField.text else { return }
        guard let image = roomImage.image else { return }
        
        showLoader(true)
        RoomService.uploadRoom(name: name, image: image) { (error) in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingRoom(controller: self)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editImage() {
        print("edit photo")
        showImagePickerControllerActionSheet()
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
