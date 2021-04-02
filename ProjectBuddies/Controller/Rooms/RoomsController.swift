//
//  RoomsViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit

private let reuseIdentifier = "RoomCell"

class RoomsController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    // MARK: - Properties
    
    private var rooms = [Room]()
    private var filteredRooms = [Room]()
    private var isFiltered : Bool = false
    
    private let searchBar: UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
        sb.obscuresBackgroundDuringPresentation = false
        sb.searchBar.placeholder = "Search room"
        return sb
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureTableView()
        fetchRooms()
        configureUI()
        setUpSearchBar()
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
    
    private func configureTableView() {
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.register(RoomCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
    }
    
    private func setupNavigationBar() {
        let joinBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinRoom))
        let createBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createRoom))
        navigationItem.rightBarButtonItem = createBarButtonItem
        navigationItem.leftBarButtonItem = joinBarButtonItem
        navigationItem.title = "Rooms"
        navigationController?.navigationBar.barTintColor = K.Color.lighterCreme
    }
    
    private func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
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
    
    // MARK: - Actions
    
    @objc func createRoom() {
        print("DEBUG: create room")
        let controller = CreateRoomController()
        controller.delegate = self
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

            RoomService.updateAfterRemovingRoom(roomId: self.rooms[indexPath.row].id, owner: self.rooms[indexPath.row].owner)
            
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
        print(filtered)
         if(filtered.count == 0){
            isFiltered = false
         } else {
            isFiltered = true
         }
         self.tableView.reloadData()
    }
}
