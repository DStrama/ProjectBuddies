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
        navigationController?.navigationBar.barTintColor = K.Color.lighterCreme
    }

    private func configureTableView() {
        view.backgroundColor = K.Color.lighterCreme
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
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

    // MARK: - Actions

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
        if notifications.count == 0 {
            self.tableView.setEmptyMessage("No notifications, when you will have notifications, you will see them here.")
        } else {
            self.tableView.restore()
        }

        return notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationIdentifier, for: indexPath) as! NotificationCell
        cell.selectionStyle = .none
        cell.delegateNotification = self
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .clear
        return footerView
    }
}

extension NotificationController: NotificationDelegate {

    func acceptedRequest(controller: NotificationCell) {
        // notification id
        guard let notificationId = controller.viewModel?.id else { return }

        //id of person who wants to join
        guard let groupNewMember = controller.viewModel?.uid else { return }

        //id of group
        guard let groupId = controller.viewModel?.groupId else { return }

        GroupService.appendMemberToGroup(groupId: groupId, memberId: groupNewMember) { error in
            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }

            NotificationService.deleteNotitfication(notificationId: notificationId) { error in
                if let error = error {
                    print("DEBUG: Failed to add room \(error.localizedDescription)")
                    return
                }
                self.fetchNotifications()
            }
        }


    }

    func declinedRequest(controller: NotificationCell) {
        guard let notificationId = controller.viewModel?.id else { return }

        NotificationService.deleteNotitfication(notificationId: notificationId) { error in
            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }
            self.fetchNotifications()
        }

    }
}
