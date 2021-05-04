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
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 22.5
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 1
        iv.layer.borderColor = K.Color.lightBlack.cgColor
        iv.layer.backgroundColor = K.Color.searchBarGray.cgColor
        return iv
    }()
    
    private let roomName: UILabel = {
        let l = UILabel()
        l.font = K.Font.largeBold
        return l
    }()
    
    let rightArrowButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = K.Color.navyApp
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
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 18, paddingBottom: 8, paddingRight: 18)
        
        container.addSubview(roomImageView)
        roomImageView.centerY(inView: container, leftAnchor: container.leftAnchor, paddingLeft: 18)
        roomImageView.setDimensions(height: 50, width: 50)
        
        container.addSubview(roomName)
        roomName.centerY(inView: roomImageView, leftAnchor: roomImageView.rightAnchor, paddingLeft: 8)
        
        container.addSubview(rightArrowButton)
        rightArrowButton.centerY(inView: self)
        rightArrowButton.anchor(top: container.topAnchor, right: container.rightAnchor, paddingRight: 18)
        
        stackMembersView.addArrangedSubview(roomMembers)
        stackMembersView.addArrangedSubview(personImageView)
        stackMembersView.addArrangedSubview(slash)
        stackMembersView.addArrangedSubview(roomGroups)
        stackMembersView.addArrangedSubview(groupImageView)
        container.addSubview(stackMembersView)
        stackMembersView.anchor(bottom: container.bottomAnchor, right: container.rightAnchor, paddingBottom: 18, paddingRight: 38, height: 20)
        
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
