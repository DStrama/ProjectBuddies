//
//  ProfileEditTextCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit

protocol EditTextDelegate: class {
    func exitTextCell(text: String, header: String)
}

class ProfileEditTextCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var delegateEdit: EditTextDelegate?
    
    private var section = String()
    
    private let titleLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.smallBold!)
        l.numberOfLines = 0
        l.backgroundColor = .clear
        return l
    }()
    
    private let editButton: UIButton = {
        let btn = UIButton(type: .system)
        let imageIcon = UIImage(systemName: "pencil")?.withTintColor(K.Color.navyApp, renderingMode: .alwaysOriginal)
        btn.setImage(imageIcon, for: .normal)
        return btn
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints( ) {
        backgroundColor = .clear
        editButton.addTarget(self, action: #selector(editElement), for: .touchUpInside)
        editButton.setDimensions(height: 30, width: 30)
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 24)
        
        
        addSubview(editButton)
        editButton.anchor(top: container.topAnchor, right: container.rightAnchor, paddingTop: 8,  paddingRight: 8)
        
        container.addSubview(titleLabel)
        titleLabel.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: editButton.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 4)

    }
    
    func settingProperties(text: String, header: String) {
        titleLabel.text = text
        section = header
        if (header == "Soft skills" || header == "Hard skills" || header == "Hobbies") {
            editButton.isHidden = true
        } else {
            editButton.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @objc private func editElement(_ sender: UIButton) {
        print("DEBUG: edit element")
        guard let title = titleLabel.text else { return }
        delegateEdit!.exitTextCell(text: title, header: section)
    }
    
}
