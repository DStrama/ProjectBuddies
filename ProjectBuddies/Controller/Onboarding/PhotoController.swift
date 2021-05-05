//
//  PhotoController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/04/2021.
//

import UIKit

protocol PhotoContinueDelegate: class {
    func continueNextPage(controller: PhotoController)
}

class PhotoController: UIViewController {
    
    weak var delegate: PhotoContinueDelegate?
    
    // MARK: - Properties
    
    let profileImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "profileImage"))
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = K.Color.searchBarGray
        iv.clipsToBounds = true
        iv.setDimensions(height: 140, width: 140)
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 59.5
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        return iv
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Color.lighterCreme
        setUpViewsAndConstraints()
    }
    
    private func setUpViewsAndConstraints() {
        continueButton.addTarget(self, action: #selector(continueOnBoarding), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(profileImage)
        profileImage.centerX(inView: view)
        profileImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 62)
        
        view.addSubview(continueButton)
        continueButton.centerX(inView: view)
        continueButton.anchor(top: profileImage.bottomAnchor, paddingTop: 62)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func continueOnBoarding() {
        self.delegate!.continueNextPage(controller: self)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        showImagePickerControllerActionSheet()
        
        // Your action
    }
}

extension PhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction,cameraAction,cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImage.image = editedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
