//
//  ConversationCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 25/04/2021.
//

import UIKit

private let reusableIdentifier = ""

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
//    var viewModel: ConversationCellViewModel? {
//        didSet{
//            configure()
//        }
//    }
    
    private var userImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerCurve = .continuous
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 17
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        iv.layer.backgroundColor = K.Color.searchBarGray.cgColor
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let l = UILabel()
        l.font = K.Font.regularBold
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()
    
    private let userMessageLabel: UILabel = {
        let l = UILabel()
        l.font = K.Font.small
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
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
        
        contentView.addSubview(userImage)
        userImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        contentView.addSubview(userNameLabel)
        userNameLabel.anchor(top: contentView.topAnchor, left: userImage.rightAnchor, right: contentView.rightAnchor)
        
        contentView.addSubview(userMessageLabel)
        userMessageLabel.anchor(top: userNameLabel.bottomAnchor, left: userImage.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 16, paddingRight: 16)
    }
    
    private func configure() {
        
    }
}
