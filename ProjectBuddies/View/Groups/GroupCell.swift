//
//  GroupCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 20/03/2021.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: GroupViewModel? {
        didSet{
            configure()
        }
    }
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let groupName: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .headline).withSize(26)
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()
    
    private let groupDescription: UILabel = {
        let l = UILabel()
        l.textAlignment = .justified
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.numberOfLines = 3
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let groupMembers: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = K.Color.gray
        l.font = K.Font.small
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
        contentView.addSubview(self.container)
        container.fillSuperview()

        container.addSubview(groupName)
        groupName.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 18, paddingLeft: 18, paddingRight: 18)
        
        container.addSubview(groupDescription)
        groupDescription.anchor(top: groupName.bottomAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 10, paddingLeft: 18, paddingRight: 18)
        
        
        stackMembersView.addArrangedSubview(groupMembers)
        stackMembersView.addArrangedSubview(personImageView)
        
        stackMembersView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackMembersView)
        stackMembersView.centerX(inView: groupDescription)
        stackMembersView.anchor(top: groupDescription.bottomAnchor, bottom: container.bottomAnchor, paddingTop: 10, paddingBottom: 18)
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        groupImageView.sd_setImage(with: viewModel.imageUrl!)
        groupName.text = viewModel.name
        groupMembers.text = "\(String(viewModel.members!))" + " / " + "\(String(viewModel.targetNumberOfPeople!))"
        groupDescription.text = String(viewModel.description!)
    }
}
