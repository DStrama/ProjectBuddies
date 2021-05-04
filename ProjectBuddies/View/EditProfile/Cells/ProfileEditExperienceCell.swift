//
//  ProfileEditCellNew.swifrt.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//


import UIKit

protocol EditExperienceDelegate: class {
    func exitExperienceCell(viewModel: ExperienceViewModel)
}

class ProfileEditExperienceCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: ExperienceViewModel? {
        didSet{ configure() }
    }
    
    public var delegateEdit: EditExperienceDelegate?
    
    private let titleLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.smallBold! )
        l.backgroundColor = .clear
        return l
    }()
    
    private let companyNameLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.tiny! )
        l.backgroundColor = .clear
        l.textColor = K.Color.lightGray
        return l
    }()
    
    private let descriptionLabel: CustomLabel = {
        let l = CustomLabel(fontType: K.Font.small! )
        l.backgroundColor = .clear
        l.numberOfLines = 0
        return l
    }()
    
    private let editButton: UIButton = {
        let btn = UIButton(type: .system)
        let imageIcon = UIImage(systemName: "pencil")?.withTintColor(K.Color.blackApp, renderingMode: .alwaysOriginal)
        btn.setImage(imageIcon, for: .normal)
        return btn
    }()
    
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
    
    private func configure() {
        titleLabel.text = viewModel?.name
        companyNameLabel.text = viewModel?.company
        descriptionLabel.text = viewModel?.description
    }
    
    private func setUpViewsAndConstraints( ) {
        backgroundColor = .clear
        editButton.addTarget(self, action: #selector(editElement), for: .touchUpInside)
        editButton.setDimensions(height: 30, width: 30)
    
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 24)
        
        container.addSubview(editButton)
        editButton.anchor(top: container.topAnchor, right: container.rightAnchor, paddingTop: 8,  paddingRight: 8)
        
        container.addSubview(titleLabel)
        titleLabel.anchor(top: container.topAnchor, left: container.leftAnchor, right: editButton.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        container.addSubview(companyNameLabel)
        companyNameLabel.anchor(top: titleLabel.bottomAnchor, left: container.leftAnchor, right: editButton.leftAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16)
        
        container.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: companyNameLabel.bottomAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    
    }
    
    func settingProperties(title: String, company: String, description: String) {
        titleLabel.text = title
        companyNameLabel.text = company
        descriptionLabel.text = description
        descriptionLabel.textAlignment = NSTextAlignment.justified
    }
    
    // MARK: - Actions
    
    @objc private func editElement(_ sender: UIButton) {
        print("DEBUG: edit element")
        delegateEdit!.exitExperienceCell(viewModel: self.viewModel!)
    }
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

