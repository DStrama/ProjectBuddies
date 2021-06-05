//
//  EditProfileExperienceController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 05/05/2021.
//

import UIKit

protocol ExprienceEditDelegate: AnyObject {
    func experienceEdit(controller: EditProfileExperienceController)
}

class EditProfileExperienceController: UIPageViewController {
    
    //MARK: - Properties
    
    var experienceEditDelegate: ExprienceEditDelegate?
    var operationType: String = String()
    var documentId: String = String()
    
    private var experienceTitle: String? = nil
    private var experienceCompany: String? = nil
    private var experienceDescription: String? = nil
    
    
    var pages = [UIViewController]()
    
    let pageControl :UIPageControl = {
        let pc = UIPageControl()
        pc.frame = CGRect()
        pc.currentPageIndicatorTintColor = K.Color.navyApp
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setupPageControl()
        setupNavigationBar()
    }
    
    //MARK: - Helpers
    
    private func setupPageControl() {
        let initialPage = 0
        
        let page1 = EditProfileExperienceTitleController()
        let page2 = EditProfileExperienceCompanyController()
        let page3 = EditProfileExperienceDescriptionController()

        page1.delegate = self
        page2.delegate = self
        page3.delegate = self
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        
        removeSwipeGesture()
        
        guard let title = experienceTitle else { return }
        page1.keyTextField.text = title
        page1.keyTextField.placeholderLabel.isHidden = true
        guard let company = experienceCompany else { return }
        page2.keyTextField.text = company
        page2.keyTextField.placeholderLabel.isHidden = true
        guard let description = experienceDescription else { return }
        page3.keyTextField.text = description
        page3.keyTextField.placeholderLabel.isHidden = true
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func saveTapped() {
        guard let title = experienceTitle else { return }
        guard let company = experienceCompany else { return }
        guard let description = experienceDescription else { return }
        
        if (operationType == "add") {
            showLoader(true)
            ExperienceService.uploadExperience(title: title, company: company, description: description) { error in
                self.showLoader(false)
                if let error = error {
                    print("Error adding experience: \(error.localizedDescription)")
                    return
                }
                self.experienceEditDelegate?.experienceEdit(controller: self)
            }
        } else {
            showLoader(true)
            ExperienceService.updateExperience(id: documentId , title: title, company: company, description: description) { error in
                self.showLoader(false)
                if let error = error {
                    print("Error adding experience: \(error.localizedDescription)")
                    return
                }
                self.experienceEditDelegate?.experienceEdit(controller: self)
            }
        }
    }
    
    func setUpProperties(title: String, company: String, description: String) {
        experienceTitle = title
        experienceCompany = company
        experienceDescription = description
    }
    
    //MARK: - Actions
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileExperienceController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension EditProfileExperienceController: EditProfileExperienceTitleDelegate {
    func continueNextPage(controller: EditProfileExperienceTitleController) {
        self.experienceTitle = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension EditProfileExperienceController: EditProfileExperienceCompanyDelegate {
    func continueNextPage(controller: EditProfileExperienceCompanyController) {
        self.experienceCompany = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension EditProfileExperienceController: EditProfileExperienceDescriptionDelegate {
    func continueNextPage(controller:  EditProfileExperienceDescriptionController) {
        self.experienceDescription = controller.keyTextField.text
        self.saveTapped()
    }
}
