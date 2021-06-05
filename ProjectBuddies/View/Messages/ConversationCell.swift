//
//  ConversationCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 25/04/2021.
//

import UIKit

private let reusableIdentifier = "conversationIdentifier"

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
//    var viewModel: ConversationViewModel? {
//        didSet{
//            configure()
//        }
//    }
//    
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
    
    private let latestMessageLabel: UILabel = {
        let l = UILabel()
        l.font = K.Font.small
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, latestMessageLabel])
        stack.axis = .vertical
        stack.spacing = 10
        contentView.addSubview(userImage)
        userImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor ,paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        
        contentView.addSubview(stack)
        stack.centerY(inView: userImage, leftAnchor: userImage.rightAnchor, paddingLeft: 8)

    }
    
    func configure(name: String, photoUrl: String, time: String, latestMessage: String) {
        userNameLabel.text = name
        userImage.sd_setImage(with: URL(string: photoUrl))
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: K.Color.gray, .font: K.Font.regular!]

        let attributedTitle = NSMutableAttributedString(string: latestMessage, attributes: atts)
        attributedTitle.append(NSMutableAttributedString(string: " - ", attributes: atts))
        attributedTitle.append(NSMutableAttributedString(string: time, attributes: atts))

        latestMessageLabel.attributedText = attributedTitle
    }
}
