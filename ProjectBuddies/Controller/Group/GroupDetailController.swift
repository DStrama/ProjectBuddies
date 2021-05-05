//
//  GroupDetailController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 02/04/2021.
//

import UIKit

private let memberReuseIdentifier = "MemberCell"

class GroupDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private var viewModel: GroupViewModel? {
        didSet{
            configure()
        }
    }
    
    private var group: Group
    var room: Room?
    
    var groupUsers: [User]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView = UIView()
    
    private let collectionAdditionalView = UIView()
    
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
        return l
    }()
    
    private let messageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle( "Message", for: .normal)
        btn.setTitleColor(K.Color.navyApp, for: .normal)
        btn.titleLabel?.font = K.Font.regular
        btn.backgroundColor = K.Color.white
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = K.Color.navyApp.cgColor
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 32)
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
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 32)
        btn.setHeight(40)
        return btn
    }()
    
    private let groupDescription: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = K.Color.blackApp
        l.sizeToFit()
        return l
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 15
        return sv
    }()
    
    private let groupMembers: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = K.Color.blackApp
        l.font = K.Font.small
        return l
    }()

    private let membersLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = K.Color.blackApp
        l.font = K.Font.small
        l.text = "Members"
        return l
    }()
    
    init(group: Group) {
        self.group = group
        self.room = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let redView: UIView = {
        let view = UIView()
        return view
    }()
    
    let greenView: UIView = {
        let view = UIView()
        return view
    }()

    let blueView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 122).isActive = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroupUsers()
        view.backgroundColor = K.Color.lighterCreme
        self.viewModel = GroupViewModel(group: self.group)
        setUpViewsAndConstraints()
        configureCollectionView()
        setupNavigationConroller()
    }
    
    // MARK: - Helpers
    
    private func setUpViewsAndConstraints() {
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.addArrangedSubview(greenView)

        greenView.addSubview(groupImage)
        groupImage.anchor(top: greenView.topAnchor, left: greenView.leftAnchor, paddingTop: 10, paddingLeft: 18)

        greenView.addSubview(groupNameLabel)
        groupNameLabel.anchor(top: groupImage.bottomAnchor, left: greenView.leftAnchor, paddingTop: 10, paddingLeft: 18)
        
        greenView.addSubview(groupMembers)
        groupMembers.centerX(inView: view)
        groupMembers.anchor(top: groupNameLabel.bottomAnchor, paddingTop: 10, paddingLeft: 18)
        
        
        stackView.addArrangedSubview(joinButton)
        stackView.addArrangedSubview(messageButton)

        greenView.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: groupMembers.bottomAnchor, bottom: greenView.bottomAnchor, paddingTop: 18)
        
        scrollViewContainer.addArrangedSubview(redView)
        redView.addSubview(groupDescription)
        groupDescription.anchor(top: redView.topAnchor, left:  redView.leftAnchor, bottom:  redView.bottomAnchor, right: redView.rightAnchor, paddingTop: 18, paddingLeft: 18, paddingRight: 18)
        
        scrollViewContainer.addArrangedSubview(blueView)

        blueView.addSubview(membersLabel)
        membersLabel.anchor(top: blueView.topAnchor, left:  blueView.leftAnchor, right: blueView.rightAnchor, paddingTop: 18, paddingLeft: 18, paddingRight: 18)
        
        blueView.addSubview(collectionView)
        collectionView.anchor(top: membersLabel.bottomAnchor, left:  blueView.leftAnchor, bottom:  blueView.bottomAnchor, right: blueView.rightAnchor, paddingLeft: 18, paddingBottom: 18, paddingRight: 18)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        groupImage.sd_setImage(with: viewModel.imageUrl)
        groupNameLabel.text = viewModel.name
        groupDescription.text = viewModel.description
        groupMembers.text =  "\(String(viewModel.members!))" + " / " + "\(String(viewModel.targetNumberOfPeople!))" + " members"
        if viewModel.members == viewModel.targetNumberOfPeople {
            joinButton.isHidden = true
        }
    }
    
    private func setupNavigationConroller() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        let imageBack = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: imageBack, style: .plain, target: self, action: #selector(backButtonTaped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MemberCell.self, forCellWithReuseIdentifier: memberReuseIdentifier)
    }

    private func fetchGroupUsers() {
        GroupService.fetchGroupMembers(groupId: group.id, completion: { members in
            self.groupUsers = members
        })
    }
    
    // MARK: - Actions
    
    @objc func joinButtonTapped() {
        guard let tab = tabBarController as? MainTabBarController else {return}
        guard let user = tab.user else { return }
        NotificationService.uploadNotification(type: .join, room: room!, group: group, user: user)
    }
    
    @objc func backButtonTaped() {
        self.navigationController?.popViewController(animated: true)
    }
}

 // MARK: - UICollectionViewDataSource

extension GroupDetailController {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupUsers?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memberReuseIdentifier, for: indexPath) as! MemberCell
        cell.viewModel = ProfileHeaderViewModel(user: (groupUsers?[indexPath.row])!)
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension GroupDetailController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProfileController(user: groupUsers![indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension GroupDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
}
