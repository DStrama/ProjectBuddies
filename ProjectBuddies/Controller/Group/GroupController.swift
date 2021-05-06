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

class GroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIPageViewControllerDelegate  {
    
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
        setupLongGestureRecognizerOnCollection()
        setupRefresh()
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
        let imageShare = UIImage(systemName: "arrowshape.turn.up.right.fill")
        let shareKey = UIBarButtonItem(image: imageShare, style: .plain, target: self, action: #selector(shareRoomKey))
        add.tintColor = K.Color.navyApp
        shareKey.tintColor = K.Color.navyApp
        navigationItem.setRightBarButtonItems([add, shareKey], animated: true)
        navigationItem.title = room!.name
        
        let imageBack = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: imageBack, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupRefresh() {
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
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    private func setUpActionSheet(indexPath: Int) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            self.handleDelateGroup(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDelateGroup(indexPath: Int) {
        GroupService.deleteGroup(group: groups[indexPath]) { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            } else {
                print("Document successfully removed!")
                self.groups.remove(at: indexPath)
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func createGroup() {
        print("DEBUG: ceate group")
        let controller = CreateGroupController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.roomId = room!.id
        controller.delegateCreateGroup = self
        controller.users = users
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func shareRoomKey() {
        showInputDialog(title: "Get a key to the room", actionTitle: "Copy", inputText: room?.id)
    }
    
    @objc func handleRefresh() {
        fetchGroups()
        fetchRoomMembers()
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView.indexPathForItem(at: p) {
            
            if indexPath.section == 1 {
                setUpActionSheet(indexPath: indexPath.row)
            }
        }
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CreateGroupDelegate

extension GroupController: CreateGroupDelegate {
    
    func controllerDidFinishUploadingGroup(controller: CreateGroupController) {
        self.handleRefresh()
        controller.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if MEMBERS_SECTION.contains(section) {
            let controller = ProfileController(user: users[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
        }
        if GROUPS_SECTION.contains(section) {
            let controller = GroupDetailController(group: groups[indexPath.row])
            controller.room = room!
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GroupController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
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

// MARK: - AlertInputDialog

extension UIViewController {
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputText:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { (textField :UITextField) in
            textField.text = inputText
            textField.keyboardType = inputKeyboardType
            textField.selectAll(self)
            self.copyToClipBoard(textToCopy: inputText!)
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true) {
            alert.textFields?.first?.selectAll(nil)
        }
    }
    
    private func copyToClipBoard(textToCopy: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = textToCopy
    }
}
