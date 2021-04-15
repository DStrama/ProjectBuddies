//
//  NotificationCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 20/03/2021.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet{
            configure()
        }
    }

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerCurve = .continuous
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 17
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    private let messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .right
        return l
    }()

    private let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Accept", for: .normal)
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.titleLabel?.font = K.Font.small
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 15
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)
        btn.setHeight(30)
        return btn
    }()
    
    private let declineButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Decline", for: .normal)
        btn.setTitleColor(K.Color.navyApp, for: .normal)
        btn.titleLabel?.font = K.Font.small
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = K.Color.navyApp.cgColor
        btn.backgroundColor = K.Color.white
        btn.layer.cornerRadius = 15
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)
        btn.setHeight(30)
        return btn
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
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
        
        stackView.addArrangedSubview(declineButton)
        stackView.addArrangedSubview(acceptButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(timeLabel)
        timeLabel.setWidth(50)
        timeLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 18, paddingRight: 12)

        addSubview(messageLabel)
        messageLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: timeLabel.leftAnchor, paddingTop: 16, paddingLeft: 8, paddingRight: 8)

        addSubview(stackView)
        stackView.centerX(inView: self)
        stackView.anchor(top: messageLabel.bottomAnchor, bottom: bottomAnchor, paddingTop: 16, paddingBottom: 8)
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        messageLabel.attributedText = viewModel.notificationMessage
        timeLabel.attributedText = viewModel.timeMessage
    }
    
    // MARK: - Actions
    
    @objc private func handleAcceptRequest() {
        
    }
    
    @objc private func handleDeclineRequest() {
        
    }
    
}
