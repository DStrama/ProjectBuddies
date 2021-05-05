//
//  onboardingController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/04/2021.
//

import UIKit

protocol Onboardingelegate: AnyObject {
    func controllerDidFinishUploadingData(controller: OnboardingController)
}

class OnboardingController: UIPageViewController {
    
    // MARK: - Properties
    
    weak var delegateUploadData: Onboardingelegate?
    
    var pages = [UIViewController]()
    
    let pageControl :UIPageControl = {
        let pc = UIPageControl()
        pc.frame = CGRect()
        pc.currentPageIndicatorTintColor = K.Color.navyApp
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()
    
    private var fullname: String? = nil
    
    private var userImage: UIImageView = {
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
        iv.image = UIImage(named: "profileImage")
        iv.tintColor = K.Color.blackApp
        return iv
    }()
    
    private var bio: String? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        setupPageControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    private func setupPageControl() {
        let initialPage = 0
        let page1 = FullnameController()
        page1.delegate = self
        let page2 = PhotoController()
        page2.delegate = self
        let page3 = BioController()
        page3.delegate = self
    
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        
        removeSwipeGesture()
        
    }
    
    private func saveUserData() {
        guard let name = self.fullname else { return }
        guard let description = self.bio else { return }
        guard let image = self.userImage.image else { return }
        
        showLoader(true)
        UserService.updateUserFiledsAfterOnbording(name: name, photo: image, bio: description) { error in
            self.showLoader(false)
            if let error = error {
                print("Error adding project: \(error.localizedDescription)")
                return
            }
            self.delegateUploadData?.controllerDidFinishUploadingData(controller: self)
        }
        
    }
    
    // MARK: - Actions
    
}

extension OnboardingController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension OnboardingController: FullnameContinueDelegate {
    func continueNextPage(controller: FullnameController) {
        guard let text = controller.keyTextField.text, !text.isEmpty else { return }
        self.fullname = text
        self.goToNextPage()
    }

}

extension OnboardingController: PhotoContinueDelegate {
    func continueNextPage(controller: PhotoController) {
        self.userImage.image = controller.profileImage.image
        self.goToNextPage()
    }

}

extension OnboardingController: BioContinueDelegate {
    func continueNextPage(controller: BioController) {
        guard let userBio = controller.keyTextField.text, !userBio.isEmpty else { return }
        self.bio = userBio
        saveUserData()
    }

}


