//
//  MemberCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 30/03/2021.
//

import UIKit

protocol MemberDelegate: class {
    func memberTapped(_ user: User)
}

class MemberCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet{
            configure()
        }
    }
    
    private let memberImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    weak var memberDelegate: MemberDelegate?
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        memberImageView.isUserInteractionEnabled = true
        memberImageView.addGestureRecognizer(tapGestureRecognizer)
        
        memberImageView.setDimensions(height: 40, width: 40)
        memberImageView.layer.cornerCurve = .continuous
        memberImageView.layer.masksToBounds = true
        memberImageView.layer.cornerRadius = 17
        memberImageView.layer.borderWidth = 0.5
        memberImageView.layer.borderColor = UIColor.gray.cgColor
        
        addSubview(memberImageView)
        memberImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        memberImageView.sd_setImage(with: viewModel.profileImageUrl!)
    }
    
    // MARK: - Actions
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        memberDelegate?.memberTapped(viewModel!.user)
    }
}
