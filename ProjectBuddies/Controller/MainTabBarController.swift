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
    
    var user: User? {
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
        setupApperance()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        UserService.fetchCurrentUser { user in
            self.user = user
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = RegistrationController()
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
        
        let rooms = templatNavigationController(unselectedImage: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, rootViewController: RoomsController(user: user), title: "Rooms")
        
        let messages = templatNavigationController(unselectedImage: UIImage(systemName: "message")!, selectedImage: UIImage(systemName: "message.fill")!, rootViewController: ConversationsController(user: user), title: "Messages")
        
        let notifications = templatNavigationController(unselectedImage: UIImage(systemName: "bell")!, selectedImage: UIImage(systemName: "bell.fill")!, rootViewController: NotificationController(), title: "Notification")
        
        viewControllers = [rooms, messages, notifications]
        
    }
     
    private func templatNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        return nav
    }
    
    private func setupApperance() {
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = K.Color.navyApp
        self.tabBar.barTintColor = K.Color.white
        self.tabBar.isTranslucent = true
        addShadow()
    }
    
    private func addShadow() {
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}

extension MainTabBarController: AuthenticationDelegate {
    func anthenticationDidComplete() {
        fetchUser()
        dismiss(animated: true, completion: nil)
    }
}
