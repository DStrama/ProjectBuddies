//
//  RoomCell.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

class RoomCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: RoomViewModel? {
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
    
    private let roomImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "logo")
        return iv
    }()
    
    private let roomName: UILabel = {
        let l = UILabel()
        l.font.withSize(16)
        return l
    }()
    
    let rightArrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return btn
    }()
    
    private let roomMembers: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.gray
        return l
    }()
    
    private let roomGroups: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.gray
        return l
    }()
    
    private let slash: UILabel = {
        let l = UILabel()
        l.textColor = K.Color.gray
        l.text = " / "
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
    
    private let groupImageView: UIImageView = {
        let i = UIImage(systemName: "person.3.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        let iv = UIImageView(image: i)
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFill
        return iv
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
        backgroundColor = K.Color.lighterCreme
        
        contentView.addSubview(self.container)
        container.fillSuperview()
        
        container.addSubview(roomImageView)
        roomImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 18, paddingLeft: 18)
        roomImageView.setDimensions(height: 52, width: 52)
        roomImageView.layer.cornerCurve = .continuous
        roomImageView.layer.masksToBounds = true
        roomImageView.layer.cornerRadius = 22.1
        roomImageView.layer.borderWidth = 0.5
        roomImageView.layer.borderColor = UIColor.gray.cgColor
        
        container.addSubview(roomName)
        roomName.centerY(inView: roomImageView, leftAnchor: roomImageView.rightAnchor, paddingLeft: 8)
        
        container.addSubview(rightArrowButton)
        rightArrowButton.centerY(inView: self)
        rightArrowButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 18)
        
        stackMembersView.addArrangedSubview(roomMembers)
        stackMembersView.addArrangedSubview(personImageView)
        stackMembersView.addArrangedSubview(slash)
        stackMembersView.addArrangedSubview(roomGroups)
        stackMembersView.addArrangedSubview(groupImageView)
        stackMembersView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackMembersView)
        stackMembersView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 18, paddingRight: 38, height: 20)
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        roomImageView.sd_setImage(with: viewModel.imageUrl!)
        roomName.text = viewModel.name
        roomMembers.text = "\(String(viewModel.members!))"
        roomGroups.text = "\(String(viewModel.groups!))"
    }
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
