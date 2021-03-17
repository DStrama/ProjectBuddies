//
//  MainTabBarController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControlllers(withUser: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureViewControlllers(withUser user: User) {
        view.backgroundColor = .white
        
        let rooms = templatNavigationController(unselectedImage: UIImage(systemName: "folder")!, selectedImage: UIImage(systemName: "folder.fill")!, rootViewController: RoomsController(), title: "Rooms")
        
        let messages = templatNavigationController(unselectedImage: UIImage(systemName: "message")!, selectedImage: UIImage(systemName: "message.fill")!, rootViewController: MessagesControlller(), title: "Messages")
        
        let notifications = templatNavigationController(unselectedImage: UIImage(systemName: "bell")!, selectedImage: UIImage(systemName: "bell.fill")!, rootViewController: NotificationControlller(), title: "Notification")
        
        let profile = templatNavigationController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!, rootViewController: ProfileController(user: user), title: "Profile")
        
        viewControllers = [rooms, messages, notifications, profile]
        
    }
     
    private func templatNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        return nav
    }
}

extension MainTabBarController: AuthenticationDelegate {
    func anthenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
