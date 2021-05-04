//
//  ProfileTextCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 19/03/2021.
//

import UIKit

class ProfileTextCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let titleLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.smallBold!)
        l.numberOfLines = 0
        l.backgroundColor = .clear
        return l
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
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setUpViewsAndConstraints() {
        backgroundColor = .clear
        
        addSubview(container)
        container.addSubview(titleLabel)
        titleLabel.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 24)

    }
    
    func setUpProperty(text: String) {
        titleLabel.text = text
    }
}
