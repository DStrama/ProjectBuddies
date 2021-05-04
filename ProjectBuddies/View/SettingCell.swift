//
//  SettingCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 08/03/2021.
//

import UIKit

class SettingCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let settingName: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.black
        return l
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
    
    private func setUpViewsAndConstraints() {
        backgroundColor = .clear
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.setDimensions(height: 50, width: 28)
        addSubview(spacer)
        
        spacer.anchor(top: topAnchor, left: leftAnchor)
        
        addSubview(settingName)
        settingName.centerY(inView: spacer, leftAnchor: spacer.rightAnchor)

    }
    
    func setProperties(name: String) {
        settingName.text = name
    }
    
}
