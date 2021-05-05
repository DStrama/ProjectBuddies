//
//  ProfileHeader.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 08/03/2021.
//

import UIKit
import SDWebImage

protocol ButtonDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UIView {

    // MARK: - Properties
    var viewModel: ProfileHeaderViewModel? {
        didSet{ configure() }
    }
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(height: 80, width: 80)
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 34
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        iv.layer.backgroundColor = K.Color.searchBarGray.cgColor
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = K.Font.regularBold
        return l
    }()
    
    private let editOrMessageButton: UIButton = {
        let btn = UIButton()
        btn.setHeight(40)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 32)
        return btn
    }()
    
    weak var editOrMessageDelegate: ButtonDelegate?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func setUpViewsAndConstraints() {
        backgroundColor = K.Color.lighterCreme
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 24)

        addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 24)
        addSubview(editOrMessageButton)
        editOrMessageButton.centerX(inView: self)
        editOrMessageButton.anchor(top: nameLabel.bottomAnchor, bottom: bottomAnchor, paddingTop: 18, paddingBottom: 18)
    }

    @objc func editProfile() {
        guard let viewModel = viewModel else { return }
        editOrMessageDelegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    private func configure() {
        profileImage.sd_setImage(with: viewModel?.profileImageUrl)
        nameLabel.text = viewModel?.fullname
        editOrMessageButton.titleLabel?.font = K.Font.regularBold
        editOrMessageButton.setTitle(viewModel?.buttonText, for: .normal)
        editOrMessageButton.backgroundColor = viewModel?.buttonBackgroundColor
        editOrMessageButton.setTitleColor(viewModel?.buttonTextColor, for: UIControl.State.normal)
    }
    
}
