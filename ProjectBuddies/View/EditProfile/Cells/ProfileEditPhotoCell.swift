//
//  ProfileEditHeaderCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 10/03/2021.
//

import UIKit

protocol editPhotoDelegate: class {
    func editPhoto(header: ProfileEditPhotoCell)
}

class ProfileEditPhotoCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet{ configure() }
    }

    weak var delegateEditPhoto: editPhotoDelegate?
    
    private let profileImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "group"))
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = K.Color.searchBarGray
        iv.clipsToBounds = true
        iv.setDimensions(height: 80, width: 80)
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 34
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setUpViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)

        backgroundColor = .clear
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, bottom:  bottomAnchor, paddingTop: 8, paddingBottom: 8)
        profileImage.centerX(inView: self)
    }
    
    func configure() {
        profileImage.sd_setImage(with: viewModel?.profileImageUrl!)
        
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("DEBUG: Edit photo")
        delegateEditPhoto?.editPhoto(header: self)
    }
    
}
