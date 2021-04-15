//
//  NotificationViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit

private let notificationIdentifier = "NofiticationCell"

class NotificationController: UITableViewController {
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        fetchNotifications()
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureNavigationBar() {
        navigationItem.title = "Notifications"
    }
    
    private func configureTableView() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: notificationIdentifier)
    }
    
    private func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
    }
}

extension NotificationController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationIdentifier, for: indexPath) as! NotificationCell
        cell.selectionStyle = .none
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        return cell
    }
}
