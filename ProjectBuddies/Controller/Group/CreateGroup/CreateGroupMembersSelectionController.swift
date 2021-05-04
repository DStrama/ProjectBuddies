//
//  CreateGroupMembersSelectionController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 26/04/2021.
//

import UIKit

protocol CreateGroupMembersSelectionDelegate: class {
    func controllerDidFinishUploadingMembers(members: [User], controller: CreateGroupMembersSelectionController)
}

struct ArrayUser {
    var user: User
    var index: Int
    var selected: Bool
}

private let reuseIdentifier = "UserCell"

class CreateGroupMembersSelectionController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    var roomId: String = ""
    
    weak var delegate: CreateGroupMembersSelectionDelegate?
    
    var arrayUsers = [ArrayUser]()
    
    var members =  [User]() {
        didSet{
            for (index, user) in members.enumerated() {
                arrayUsers.append(ArrayUser(user: user, index: index, selected: false))
            }
        }
    }
    
    private var filteredMembers = [ArrayUser]()
    
    private var isFiltered: Bool = false
    
    let searchController: UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
        sb.searchBar.placeholder = "Search members..."
        return sb
    }()
        
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        setUpViewsAndConstraints()
        view.backgroundColor = K.Color.lighterCreme
        navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let backBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(addMembers))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.rightBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

    }
    
    private func configureSearchBar() {
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("Save", forKey: "cancelButtonText")
        searchController.automaticallyShowsCancelButton = false
    }
    
    private func configureTableView() {
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    
    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.creme
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - Actions
    
    @objc func addMembers() {
        
        var selectedMembers: [User] = []
        arrayUsers.forEach { userObject in
            if userObject.selected == true {
                selectedMembers.append(userObject.user)
            }
        }
        
        if selectedMembers.isEmpty {
            return
        } else {
            self.delegate?.controllerDidFinishUploadingMembers(members: selectedMembers, controller: self)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CreateGroupMembersSelectionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let tmp = isFiltered ? filteredMembers[indexPath.row] :  arrayUsers[indexPath.row]
        cell.viewModel = ProfileHeaderViewModel(user: tmp.user)
        cell.accessoryType = tmp.selected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmp = isFiltered ? filteredMembers[indexPath.row] : arrayUsers[indexPath.row]
        let id = tmp.index
        
        arrayUsers[id].selected = !arrayUsers[id].selected
        
        if isFiltered {
            for (index,user) in filteredMembers.enumerated() {
                if(user.index == id){
                    filteredMembers[index].selected = !user.selected
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredMembers.count : arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension CreateGroupMembersSelectionController {
    
    func searchBar(searchBar: UISearchBar, textDidChange textSearched: String)
    {
        let text = searchBar.text!.lowercased()
        if(!text.isEmpty) {
            let filtered = arrayUsers.filter({ $0.user.fullname.lowercased().contains(text)})
            filteredMembers = filtered
             if(filtered.count == 0){
                isFiltered = false
             } else {
                isFiltered = true
             }
        } else {
            isFiltered = false
            
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!.lowercased()
        if(!text.isEmpty) {
            let filtered = arrayUsers.filter({ $0.user.fullname.lowercased().contains(text)})
            filteredMembers = filtered
             if(filtered.count == 0){
                isFiltered = false
             } else {
                isFiltered = true
             }
        } else {
            isFiltered = false

        }
        self.tableView.reloadData()
    }

}
