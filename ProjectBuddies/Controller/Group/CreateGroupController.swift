//
//  GroupController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

protocol CreateGroupDelegate: class {
    func controllerDidFinishUploadingGroup(controller: CreateGroupController)
}

class CreateGroupController: UIViewController {
    
    // MARK: - Properties
    
    let scrollView: UIScrollView = {
         let v = UIScrollView()
         v.translatesAutoresizingMaskIntoConstraints = false
         return v
    }()
    
    let contentView = UIView()
    
    var roomId = String()
    
    weak var delegate: CreateGroupDelegate?
    
    private var groupImage: UIImageView = {
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
        l.text = "Group Name"
        return l
    }()
    
    private lazy var titleTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Enter title.."
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var titleCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    
    private var descriptionLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Description"
        return l
    }()
    
    private lazy var descriptionTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Ex: our idea for project is ..."
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
    
    private var membersNumberLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Number of members"
        return l
    }()
    
    private lazy var membersNumberTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Ex: 1"
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var membersNumberCharacterCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.lightGray
        l.font = K.Font.small
        return l
    }()
    
    private var membersTargetNumberLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Target number of members"
        return l
    }()
    
    
    private lazy var membersTargetNumberTextField: InputTextView = {
        var tv = InputTextView()
        tv.placeholderText = "Ex: 1"
        tv.font = K.Font.regular
        tv.delegate = self
        tv.backgroundColor = K.Color.white
        return tv
    }()
    
    private var membersTargetNumberCharacterCountLabel: UILabel = {
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
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        navigationItem.title = "Create group"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func setUpViewsAndConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        view.backgroundColor = K.Color.lighterCreme
        titleCharacterCountLabel.text = "0/40"
        descriptionCharacterCountLabel.text = "0/300"
        membersNumberCharacterCountLabel.text = "0/3"
        membersTargetNumberCharacterCountLabel.text = "0/3"
        
        editButton.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        scrollView.isUserInteractionEnabled = true
        
        contentView.addSubview(groupImage)
        groupImage.anchor(top: contentView.topAnchor, paddingTop: 10)
        groupImage.centerX(inView: contentView)

        contentView.addSubview(editButton)
        editButton.centerX(inView: groupImage)
        editButton.anchor(top: groupImage.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingBottom: 8)

        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: editButton.bottomAnchor, left: contentView.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

        contentView.addSubview(titleTextField)
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 35)

        contentView.addSubview(titleCharacterCountLabel)
        titleCharacterCountLabel.anchor(top: titleTextField.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingRight: 12)


        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleCharacterCountLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

        contentView.addSubview(descriptionTextField)
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 100)

        contentView.addSubview(descriptionCharacterCountLabel)
        descriptionCharacterCountLabel.anchor(top: descriptionTextField.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingRight: 12)


        contentView.addSubview(membersNumberLabel)
        membersNumberLabel.anchor(top: descriptionTextField.bottomAnchor, left: contentView.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

        contentView.addSubview(membersNumberTextField)
        membersNumberTextField.anchor(top: membersNumberLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 35)

        contentView.addSubview(membersNumberCharacterCountLabel)
        membersNumberCharacterCountLabel.anchor(top: membersNumberTextField.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingRight: 12)

        contentView.addSubview(membersTargetNumberLabel)
        membersTargetNumberLabel.anchor(top: membersNumberTextField.bottomAnchor, left: contentView.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

        contentView.addSubview(membersTargetNumberTextField)
        membersTargetNumberTextField.anchor(top: membersTargetNumberLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 35)

        contentView.addSubview(membersTargetNumberCharacterCountLabel)
        membersTargetNumberCharacterCountLabel.anchor(top: membersTargetNumberTextField.bottomAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingRight: 12)

        
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    // MARK: - Actions
    
    @objc func doneTapped() {
        guard let name = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let image = groupImage.image else { return }
        guard let numberOfPeople = Int(membersNumberTextField.text!) else { return }
        guard let targetNumberOfPeople = Int(membersTargetNumberTextField.text!) else { return }
        
        showLoader(true)
        GroupService.uploadGroup(name: name, description: description, image: image, members: numberOfPeople, targetMembers: targetNumberOfPeople, roomId: roomId) { error in
            self.showLoader(false)
            if let error = error {
                print("Error removing document: \(error)")
                return
            } else {
                
                print("Document successfully removed!")
            }
            self.delegate?.controllerDidFinishUploadingGroup(controller: self)
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editImage() {
        print("edit photo")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreateGroupController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === titleTextField {
            checkMaxLength(textView, maxLength: 35)
            let count = textView.text.count
            titleCharacterCountLabel.text = "\(count)/35"
        } else if textView === descriptionTextField {
            checkMaxLength(textView, maxLength: 300)
            let count = textView.text.count
            descriptionCharacterCountLabel.text = "\(count)/300"
        } else if textView === membersNumberTextField {
            checkMaxLength(textView, maxLength: 3)
            let count = textView.text.count
            titleCharacterCountLabel.text = "\(count)/3"
        } else if textView === membersTargetNumberTextField {
            checkMaxLength(textView, maxLength: 3)
            let count = textView.text.count
            titleCharacterCountLabel.text = "\(count)/3"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
}
