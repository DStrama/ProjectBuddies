//
//  GroupController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

private let groupReuseIdentifier = "GroupCell"
private let memberReuseIdentifier = "MemberCell"

fileprivate let MEMBERS_SECTION: [Int] = [0]
fileprivate let GROUPS_SECTION: [Int] = [1]

class GroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    // MARK: - Properties
    private var groups = [Group]()
    private var users = [User]()
    var room :Room? 
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.makeLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.fillSuperview()
        collectionView.backgroundColor = K.Color.lighterCreme
        setupNavigationBar()
        fetchGroups()
        fetchRoomMembers()
        configureCollectionView()
    }

    // MARK: - API
    
    private func fetchGroups() {
        GroupService.fetchGroups(roomId: room!.id) { groups in
            self.groups = groups
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func fetchRoomMembers() {
        RoomService.fetchRoomMembers(roomId: room!.id) { users in
            self.users = users
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createGroup))
        navigationItem.rightBarButtonItem = add
        navigationItem.title = room!.name
    }
    
    private func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MemberCell.self, forCellWithReuseIdentifier: memberReuseIdentifier)
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: groupReuseIdentifier)
    }
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if MEMBERS_SECTION.contains(section) {
                return LayoutBuilder.buildHorizontalTableSectionLayout()
            }
            
            return LayoutBuilder.buildVerticalTableSectionLayout()
        }
        return layout
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // MARK: - Actions
    
    @objc private func createGroup() {
        print("DEBUG: ceate group")
        let controller = CreateGroupController()
        controller.roomId = room!.id
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRefresh() {
        groups.removeAll()
        fetchGroups()
    }
}

// MARK: - CreateGroupDelegate

extension GroupController: CreateGroupDelegate {
    
    func controllerDidFinishUploadingGroup(controller: CreateGroupController) {
        self.handleRefresh()
        controller.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = GroupDetailController(group: groups[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GroupController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MEMBERS_SECTION.contains(section) {
            return users.count
        }
        if GROUPS_SECTION.contains(section) {
            return groups.count 
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if MEMBERS_SECTION.contains(indexPath.section) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memberReuseIdentifier, for: indexPath) as! MemberCell
            cell.viewModel = ProfileHeaderViewModel(user: users[indexPath.row])
            cell.memberDelegate = self
            return cell
        }
        if GROUPS_SECTION.contains(indexPath.section) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: groupReuseIdentifier, for: indexPath) as! GroupCell
            cell.viewModel = GroupViewModel(group: groups[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    

}

// MARK: - MemberDelegate

extension GroupController: MemberDelegate {
    func memberTapped(_ user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
