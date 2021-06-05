//
//  NewConversationViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 25/04/2021.
//

import UIKit
import JGProgressHUD

private let newConversationIdentifier = "newConversationIdentifier"

final class NewConversationController: UIViewController {
    
    var user: User?
    
    private var users = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let spinner = JGProgressHUD()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for users..."
        return sb
    }()
    
    private let tableView: UITableView = {
        let t = UITableView()
        t.estimatedRowHeight = 72
        t.register(NewConversationCell.self, forCellReuseIdentifier: newConversationIdentifier)
        return t
    }()
    
    private let noResultsLabel: UILabel = {
        let l = UILabel()
        l.text = "No results found"
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        setupNavigationBar()
        setupTableView()
        setupSarchBar()
        setupViewAndConstraints()
    }
    
    private func setupSarchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        let backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.rightBarButtonItem = backBarButtonItem
    }
    
    private func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
        }
    }
    
    private func setupViewAndConstraints() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        
    }
    
    @objc private func cancelTapped() {
        navigationController?.popToViewController(ofClass: ConversationsController.self)
    }
    

}

extension NewConversationController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

extension NewConversationController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChatController()
        controller.currentUser = self.user
        controller.secondUser = self.users[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension NewConversationController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newConversationIdentifier, for: indexPath) as! NewConversationCell
        cell.configure(name: users[indexPath.row].fullname, photoUrl: users[indexPath.row].profileImageUrl)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
}
