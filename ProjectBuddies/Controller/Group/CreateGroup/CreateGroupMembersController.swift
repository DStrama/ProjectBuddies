//
//  SearchMembersController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 09/04/2021.
//

import UIKit

protocol CreateGroupMembersDelegate: class {
    func continueNextPage(members: [User], controller: CreateGroupMembersSelectionController)
}

class CreateGroupMembersController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CreateGroupMembersDelegate?
    
    var roomId: String = ""
    
    var members = [User]()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Select group\nmembers"
        l.numberOfLines = 3
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    private let selectPeopleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Select people", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 48, bottom: 8, right: 48)
        btn.setHeight(40)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsAndConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Helpers

    private func setUpViewsAndConstraints() {
        selectPeopleButton.addTarget(self, action: #selector(selectPeopleTapped), for: .touchUpInside)
        view.backgroundColor = K.Color.lighterCreme
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 56, paddingRight: 56)
        
        view.addSubview(selectPeopleButton)
        selectPeopleButton.centerX(inView: view)
        selectPeopleButton.anchor(top: titleLabel.bottomAnchor, paddingTop: 32)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func selectPeopleTapped() {
        let controller = CreateGroupMembersSelectionController()
        controller.delegate = self
        controller.roomId = roomId
        controller.members = members
        let navVC = UINavigationController(rootViewController: controller)
        present(navVC, animated: true)
    }
    
}

extension CreateGroupMembersController: CreateGroupMembersSelectionDelegate {
    func controllerDidFinishUploadingMembers(members: [User], controller: CreateGroupMembersSelectionController) {
        delegate?.continueNextPage(members: members, controller: controller)
    }
}
