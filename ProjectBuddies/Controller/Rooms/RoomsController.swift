//
//  RoomsViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit
import Firebase

private let reuseIdentifier = "RoomCell"

class RoomsController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UIPageViewControllerDelegate {
    // MARK: - Properties
    
    var user: User {
        didSet {
            setupNavigationBar()
        }
    }
    var viewModel: ProfileHeaderViewModel?
    
    private var rooms = [Room]()
    private var filteredRooms = [Room]()
    private var isFiltered : Bool = false
    
    private let searchBar: UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
        sb.obscuresBackgroundDuringPresentation = false
        sb.searchBar.placeholder = "Search room"
        return sb
    }()
    
    private let createButton: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.setHeight(40)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        btn.backgroundColor = K.Color.navyApp
        btn.titleLabel!.font = K.Font.regularBold
        btn.setTitleColor(K.Color.lighterCreme, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 32)
        btn.setTitle("Start a room", for: .normal)
        return btn
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 30, width: 30)
        iv.layer.cornerCurve = .continuous
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12.75
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    init(user: User) {
        self.user = user
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureTableView()
        fetchRooms()
        configureUI()
        setUpSearchBar()
        checkIfUserHasData()
    }

    // MARK: - API
    
    private func fetchRooms() {
        RoomService.fetchUserRooms { rooms in
            self.rooms = rooms
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func checkIfUserHasData() {
        if self.user.fullname == "" || self.user.aboutme == "" {
            DispatchQueue.main.async {
                let controller = OnboardingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                controller.delegateUploadData = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func configureTableView() {
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.register(RoomCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
    }
    
    private func setupNavigationBar() {
        let joinBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinRoom))
        joinBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = joinBarButtonItem

        self.viewModel = ProfileHeaderViewModel(user: self.user)
        profileImageView.sd_setImage(with: self.viewModel?.profileImageUrl)
        let profileBarButtonItem = UIBarButtonItem.init(customView: profileImageView)
        
        navigationItem.rightBarButtonItem = profileBarButtonItem
        
        navigationItem.title = "Rooms"
        
        navigationController?.navigationBar.barTintColor = K.Color.lighterCreme
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    
        view.addSubview(createButton)
        createButton.centerX(inView: view)
        createButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 30)
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.hidesNavigationBarDuringPresentation = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.sizeToFit()
    }
    
    private func fetchUser() {
        UserService.fetchUser(userId: user.uid) { user in
            self.user = user
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func createRoom() {
        print("DEBUG: create room")
        let controller = CreateRoomController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.delegateCreateRoom = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func joinRoom() {
        print("DEBUG: join room")
        let controller = JoinRoomController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRefresh() {
        rooms.removeAll()
        fetchRooms()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let controller = ProfileController(user: user)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RoomsController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredRooms.count : rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RoomCell
        let tmp = isFiltered ? filteredRooms[indexPath.row] :  rooms[indexPath.row]
        cell.viewModel = RoomViewModel(room: tmp)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in

            RoomService.updateAfterRemovingRoom(room: self.rooms[indexPath.row])
            
            self.rooms.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = K.Color.red
        
        return action
    }
}

// MARK: - UITableViewDelegate

extension RoomsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = GroupController()
        controller.room = self.rooms[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - CreateRoomDelegate

extension RoomsController: CreateRoomDelegate {
    
    func controllerDidFinishUploadingRoom(controller: CreateRoomController) {
        self.handleRefresh()
        controller.navigationController?.popViewController(animated: true)
    }
}

// MARK: - JoinRoomDelegate

extension RoomsController: JoinRoomDelegate {
    
    func controllerDidFinishUploadingRoom(controller: JoinRoomController) {
        self.handleRefresh()
        controller.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension RoomsController {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!.lowercased()
        let filtered = rooms.filter({ $0.name.lowercased().contains(text)})
        filteredRooms = filtered
         if(filtered.count == 0){
            isFiltered = false
         } else {
            isFiltered = true
         }
         self.tableView.reloadData()
    }
}

// MARK -

extension RoomsController: Onboardingelegate {
    func controllerDidFinishUploadingData(controller: OnboardingController) {
        fetchUser()
        controller.navigationController?.popViewController(animated: true)
    }
}

extension RoomsController: ProfileDelegate {
    func editedFields(controller: ProfileController) {
        self.user.profileImageUrl = controller.user.profileImageUrl
    }
}
