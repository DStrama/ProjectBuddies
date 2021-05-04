//
//  CustomLabel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//
import UIKit

class CustomTextField: UITextField {
    init(placeholder: String, txtColor: UIColor, bgColor: UIColor) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        textColor = .black
        keyboardType = .emailAddress
        backgroundColor = bgColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: K.Color.lightGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

