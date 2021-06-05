//
//  MessagesController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit
import JGProgressHUD

private let conversationIdentifier = "ConversationCell"

class ConversationsController: UITableViewController {
    
    //MARK: - Properties
    
    var user: User?
    
    private var conversations = [Chat?]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchConversations()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupTableView() {
        view.backgroundColor = K.Color.lighterCreme
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.register(ConversationCell.self, forCellReuseIdentifier: conversationIdentifier)
    }

    private func setupNavigationBar() {
        let writeMesssageBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                         target: self,
                                                         action: #selector(didTapComposeButton))
        writeMesssageBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.rightBarButtonItem = writeMesssageBarButtonItem
    }
    
    private func fetchConversations() {
        MessageService.fetchAllUserConversations { conversations in
            self.conversations = conversations
        }
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationController()
        vc.user = self.user
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
}

// MARK: - TableViewDelegate

extension ConversationsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChatController()
        controller.currentUser = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - TableViewDataSource

extension ConversationsController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationIdentifier, for: indexPath) as! ConversationCell
//        cell.configure(name: <#T##String#>, photoUrl: <#T##String#>, time: <#T##String#>, latestMessage: <#T##String#>)
//        
//        cell.textLabel?.text = conversations[indexPath.row]?.

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if conversations.count == 0 {
            self.tableView.setEmptyMessage("No messages, when you will have messages, you will see them here.")
        } else {
            self.tableView.restore()
        }

        return conversations.count
    }
    
}
