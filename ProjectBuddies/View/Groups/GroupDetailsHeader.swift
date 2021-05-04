//
//  GroupDetailsHeader.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 10/04/2021.
//

import UIKit

class GroupDetailsHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var viewModel: GroupViewModel? {
        didSet{
            configure()
        }
    }
    
    private var groupImage: UIImageView = {
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
    
    private let groupNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = K.Font.largeBold
        l.text = "The best group"
        return l
    }()
    
    private let messageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Message", for: .normal)
        btn.setTitleColor(K.Color.navyApp, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.white
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        btn.setHeight(40)
        return btn
    }()
    
    
    private let joinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Join", for: .normal)
        btn.setTitleColor(K.Color.white, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.navyApp
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        btn.setHeight(40)
        return btn
    }()
    
    private var descriptionLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Description"
        return l
    }()
    
    private let groupDescription: UILabel = {
        let l = UILabel()
        l.textAlignment = .justified
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.sizeToFit()
        return l
    }()
    
    private let stackButtonsView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 10
        return sv
    }()
    
    private let groupMembers: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = K.Color.gray
        return l
    }()
    
    private let stackMembersView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 2
        return sv
    }()
    
    private let personImageView: UIImageView = {
        let i = UIImage(systemName: "person.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        let iv = UIImageView(image: i)
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
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

        addSubview(groupImage)
        groupImage.anchor(top: self.layoutMarginsGuide.topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 18)
        
        addSubview(groupNameLabel)
        groupNameLabel.anchor(top: groupImage.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 18)
         
        stackButtonsView.addArrangedSubview(joinButton)
        stackButtonsView.addArrangedSubview(messageButton)
        
        addSubview(stackButtonsView)
        stackButtonsView.centerX(inView: self)
        stackButtonsView.anchor(top: groupNameLabel.bottomAnchor, paddingTop: 18)
        
        addSubview(groupDescription)
        groupDescription.anchor(top: stackButtonsView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 18, paddingLeft: 18, paddingRight: 18)

        stackMembersView.addArrangedSubview(groupMembers)
        stackMembersView.addArrangedSubview(personImageView)
        
        stackMembersView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackMembersView)
        stackMembersView.anchor(top: groupDescription.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 18, paddingLeft: 18)
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        groupImage.sd_setImage(with: viewModel.imageUrl)
        groupNameLabel.text = viewModel.name
        groupDescription.text = viewModel.description
        groupMembers.text = "\(String((viewModel.members!))) " + "/ " + "\(String(((viewModel.targetNumberOfPeople!))))"
    }
}
