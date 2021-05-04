//
//  ProfileEditHeaderWithoutAdding.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit

class ProfileEditHeaderWithoutAdding: UIView {
    
    // MARK: - Properties
    
    private let nameLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.regular!)
        return l
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
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 18)
    }
    
    func settingProperties(title: String) {
        nameLabel.text = title
    }
    
}
