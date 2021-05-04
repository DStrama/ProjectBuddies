//
//  ProfileEditHeaderSection.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit

protocol addElementDelegate {
    func actionOnHeader(headerType: String, sec: Int, idx: Int)
}

class ProfileEditHeaderSection: UIView {
    
    // MARK: - Properties
    
    private let nameLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.regular!)
        l.textColor = K.Color.blackApp
        return l
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(addElement), for: .touchUpInside)
        return btn
    }()
    
    var indexPathRow: Int = 0
    
    var section: Int = 0
    
    var delegateElement: addElementDelegate?
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints() {
        addButton.setDimensions(height: 40, width: 40)
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)

        
        container.addSubview(nameLabel)
        nameLabel.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4)
        
        container.addSubview(addButton)
        addButton.anchor(top: container.topAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 16)
    }
    
    func settingProperties(title: String, typeButton: String, sectionArg: Int, indexPathRowArg: Int) {
        section = sectionArg
        indexPathRow = indexPathRowArg
        nameLabel.text = title
        let imageIcon = UIImage(systemName: typeButton)?.withTintColor(K.Color.white, renderingMode: .alwaysOriginal)
        addButton.backgroundColor = K.Color.navyApp
        addButton.layer.cornerRadius = 20
        addButton.setImage(imageIcon, for: .normal)
    }
    
    @objc func addElement() {
        print("DEBUG: add new element")
        delegateElement!.actionOnHeader(headerType: nameLabel.text!, sec: section, idx: indexPathRow)
    }
    
}

