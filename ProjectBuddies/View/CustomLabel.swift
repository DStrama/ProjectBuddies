//
//  CustomLabel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

class CustomLabel: UILabel {
    init(context: String, fontType: UIFont) {
        super.init(frame: .zero)
        text = context
        numberOfLines = 0
        sizeToFit()
        textColor = K.Color.black
        font = fontType
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
