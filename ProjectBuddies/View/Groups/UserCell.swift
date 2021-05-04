//
//  UserCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 09/04/2021.
//

import UIKit

class UserCell: UITableViewCell {
    
    var viewModel: ProfileHeaderViewModel? {
        didSet{
            configure()
        }
    }
    
    private var memberImage: UIImageView = {
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
    
    private let memberName: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .headline).withSize(14)
        l.numberOfLines = 0
        l.textAlignment = .left
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViewsAndConstraints() {
        backgroundColor = K.Color.lighterCreme
        
        addSubview(memberImage)
        memberImage.centerY(inView: self)
        memberImage.anchor(left: leftAnchor, paddingLeft: 18)
        
        addSubview(memberName)
        memberName.centerY(inView: self)
        memberName.anchor(left: memberImage.rightAnchor, right: rightAnchor, paddingLeft: 18, paddingRight: 8)
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        memberImage.sd_setImage(with: viewModel.profileImageUrl!)
        memberName.text = viewModel.fullname
    }
}
