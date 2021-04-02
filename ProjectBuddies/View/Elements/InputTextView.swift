//
//  InputTextView.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 31/03/2021.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK: Properties
    
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    let placeholderLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        return l
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layer.borderColor = K.Color.lightGray.cgColor
        layer.borderWidth = 0.5
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChanged), name: UITextView.textDidChangeNotification, object: .none)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc func handleTextDidChanged() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
