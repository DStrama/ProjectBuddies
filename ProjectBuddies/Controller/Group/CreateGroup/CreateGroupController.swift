//
//  GroupController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

protocol CreateGroupDelegate: class {
    func controllerDidFinishUploadingGroup(controller: CreateGroupController)
}

class CreateGroupController: UIPageViewController {
    
    // MARK: - Properties
    
    weak var delegateCreateGroup: CreateGroupDelegate?
    
    private var groupName: String? = nil
    private var groupDescription: String? = nil
    private var targetMembers: Int? = nil
    private var groupImage: UIImage? = nil
    private var groupMembers: [User]? = nil
    
    var pages = [UIViewController]()
    
    let pageControl :UIPageControl = {
        let pc = UIPageControl()
        pc.frame = CGRect()
        pc.currentPageIndicatorTintColor = K.Color.navyApp
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()
    
    var roomId = String()
    var users = [User]()
    var selectedUsers = [User]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setupNavigationBar()
        setupPageControl()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setupPageControl() {
        let initialPage = 0
        
        let page1 = CreateGroupNameController()
        let page2 = CreateGroupDescriptionController()
        let page3 = CreateGroupTargetMembersController()
        let page4 = CreateGroupMembersController()
        page4.roomId = roomId
        page4.members = users
        let page5 = CreateGroupPhotoController()

        page1.delegate = self
        page2.delegate = self
        page3.delegate = self
        page4.delegate = self
        page5.delegate = self
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        self.pages.append(page4)
        self.pages.append(page5)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        
        removeSwipeGesture()
    }

    private func saveGroup() {
        guard let name = groupName, !name.isEmpty else { return }
        guard let description = groupDescription, !description.isEmpty else { return }
        guard let target = targetMembers else { return }
        guard let members = groupMembers else { return }
        guard let image = groupImage else { return }
        
        showLoader(true)
        GroupService.uploadGroup(name: name, description: description, image: image, members: members, targetMembers: target, roomId: roomId) { error in
            self.showLoader(false)
            if let error = error {
                print("Error removing document: \(error)")
                return
            } else {
                
                print("Document successfully removed!")
            }
            self.delegateCreateGroup?.controllerDidFinishUploadingGroup(controller: self)
        }
    }
    
    // MARK: - Actions
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension CreateGroupController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
            
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentController = pageViewController.viewControllers?.first else {
         return 0 }
        guard let index = pages.firstIndex(of: currentController) else { return 0 }
        return index
    }
    
}

extension CreateGroupController: CreateGroupNameDelegate {
    func continueNextPage(controller: CreateGroupNameController) {
        self.groupName = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension CreateGroupController: CreateGroupDescriptionDelegate {
    func continueNextPage(controller: CreateGroupDescriptionController) {
        self.groupDescription = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension CreateGroupController: CreateGroupPhotoDelegate {
    func continueNextPage(controller: CreateGroupPhotoController) {
        self.groupImage = controller.roomImage.image
        self.saveGroup()
    }
}

extension CreateGroupController: CreateGroupTargetMembersDelegate {
    func continueNextPage(controller: CreateGroupTargetMembersController) {
        self.targetMembers = controller.targetNumber
        self.goToNextPage()
    }
}

extension CreateGroupController: CreateGroupMembersDelegate {
    func continueNextPage(members: [User], controller: CreateGroupMembersSelectionController) {
        self.groupMembers = members
        self.goToNextPage()
    }
}

