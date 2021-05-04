//
//  SettingsControllr.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit
import Firebase

private let reuseIdentifier = "SettingCell"

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    private let names = [
        1 : ["Feedback": ["Rate Our App", "Share the App with Friends"]],
        2 : ["Support": ["Get help", "See terms and privacy"]],
        3 : ["Actions": ["Logout"]],
    ]
    
    private var objectArray = [Objects]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortingDataAndPopulating()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Helpers
    
    private func sortingDataAndPopulating(){
        let sorted = names.sorted {$0.key < $1.key}
        
        for element in sorted {
            for dict in element.value {
                objectArray.append(Objects(sectionName: dict.key, sectionObjects: dict.value))
            }
        }
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backToProfile))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Settings"
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @objc func backToProfile() {
        self.navigationController?.popViewController(animated: true)
    }
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
}

// MARK: - TableViewDataSource

extension SettingsController {
    
    override func numberOfSections(in _: UITableView) -> Int {
        return objectArray.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        cell.setProperties(name: objectArray[indexPath.section].sectionObjects[indexPath.row])
        return cell
    }

//    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return objectArray[section].sectionName
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let label = UILabel(frame: CGRect(x: 24, y: 10, width: tableView.frame.width, height: 20))
        label.font = K.Font.regularBold
        label.textColor = K.Color.white
        label.text = objectArray[section].sectionName
        label.textAlignment = .left
        view.addSubview(label)
        view.backgroundColor = K.Color.navyApp
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

        } else if indexPath.section == 1{
        
        } else if indexPath.section == 2{
            switch indexPath.row {
            case 0:

                do {
                    try Auth.auth().signOut()
                    let controller = RegistrationController()
                    controller.delegate = self.tabBarController as? MainTabBarController
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
                
            default:
                break
            }
        }
    }
}
