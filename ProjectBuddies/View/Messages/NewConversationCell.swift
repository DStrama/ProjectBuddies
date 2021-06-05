//
//  NewConversationCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 04/06/2021.
//

import UIKit

private let reusableIdentifier = "newConversationIdentifier"

class NewConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
//    var viewModel: NewConversationViewModel? {
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
        
        contentView.addSubview(userImage)
        userImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        
        contentView.addSubview(userNameLabel)
//        userNameLabel.anchor(left: userImage.rightAnchor, right: contentView.rightAnchor)
        userNameLabel.centerY(inView: userImage, leftAnchor: userImage.rightAnchor, paddingLeft: 16)
        
    }
    
    func configure(name: String, photoUrl: String) {
        userNameLabel.text = name
        userImage.sd_setImage(with: URL(string: photoUrl))
        
//        guard let viewModel = viewModel else { return }
//        userImage.sd_setImage(with: viewModel.imageUrl!)
//        userNameLabel.text = viewModel.name
    }
}
