//
//  RoomController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 15/03/2021.
//

import UIKit

protocol CreateRoomDelegate: class {
    func controllerDidFinishUploadingRoom(controller: CreateRoomController)
}

class CreateRoomController: UIPageViewController, UITextViewDelegate, CreateRoomPhotoDelegate, CreateRoomNameDelegate {

    // MARK: - Properties
    
    weak var delegateCreateRoom: CreateRoomDelegate?
    
    var pages = [UIViewController]()
    
    let pageControl :UIPageControl = {
        let pc = UIPageControl()
        pc.frame = CGRect()
        pc.currentPageIndicatorTintColor = K.Color.navyApp
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()
    
    private var roomImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(height: 80, width: 80)
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 34
        iv.layer.cornerCurve = CALayerCornerCurve.continuous
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = K.Color.gray.cgColor
        iv.backgroundColor = K.Color.searchBarGray
        iv.image = UIImage(systemName: "group")
        iv.tintColor = K.Color.blackApp
        return iv
    }()
    
    private var roomName: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.dataSource = self
        self.delegate = self
        
        setupPageControl()
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
        
        let page1 = CreateRoomNameController()
        let page2 = CreateRoomPhotoController()
        
        page1.delegate = self
        page2.delegate = self
        
        self.pages.append(page1)
        self.pages.append(page2)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        
        removeSwipeGesture()

    }
    
    private func saveRoom() {
        guard let name = roomName, !name.isEmpty else { return }
        guard let image = roomImage.image else { return }

        showLoader(true)
        RoomService.uploadRoom(name: name, image: image) { error in
            self.showLoader(false)

            if let error = error {
                print("DEBUG: Failed to add room \(error.localizedDescription)")
                return
            }

            self.delegateCreateRoom?.controllerDidFinishUploadingRoom(controller: self)
        }
    }
    
    // MARK: - Actions

    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateRoomController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension CreateRoomController {
    
    func continueNextPage(controller: CreateRoomNameController) {
        self.roomName = controller.keyTextField.text
        self.goToNextPage()
    }
    
    func continueNextPage(controller: CreateRoomPhotoController) {
        self.roomImage.image = controller.roomImage.image
        self.saveRoom()
    }
}
