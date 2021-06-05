//
//  EditProfileAddProjectController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit

protocol ProjectEditDelegate: AnyObject {
    func projectEdit(controller: EditProfileProjectController)
}

class EditProfileProjectController: UIPageViewController  {
    
    var projectEditDelegate: ProjectEditDelegate?
    var operationType: String = String()
    var documentId: String = String()
    
    private var projectName: String? = nil
    private var projectDescription: String? = nil
    private var projectTechnologies: String? = nil
    
    var pages = [UIViewController]()
    
    let pageControl :UIPageControl = {
        let pc = UIPageControl()
        pc.frame = CGRect()
        pc.currentPageIndicatorTintColor = K.Color.navyApp
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setupNavigationBar()
        setupPageControl()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupPageControl() {
        let initialPage = 0
        
        let page1 = EditProfileProjectNameController()
        let page2 = EditProfileProjectDescriptionController()
        let page3 = EditProfileProjectTechnologiesController()


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
        
        guard let title = projectName else { return }
        page1.keyTextField.text = title
        page1.keyTextField.placeholderLabel.isHidden = true
        guard let description = projectDescription else { return }
        page2.keyTextField.text = description
        page2.keyTextField.placeholderLabel.isHidden = true
        guard let technologies = projectTechnologies else { return }
        page3.keyTextField.text = technologies
        page3.keyTextField.placeholderLabel.isHidden = true
    }
    
    func setUpProperties(title: String, description: String, technologies: String) {
        projectName = title
        projectDescription = description
        projectTechnologies = technologies
    }
    
    private func saveTapped() {
        guard let title = projectName else { return }
        guard let description = projectDescription else { return }
        guard let technologies = projectTechnologies else { return }

        if (operationType == "add") {
            showLoader(true)
            ProjectService.uploadProject(title: title, description: description, technologies: technologies) { error in
                self.showLoader(false)
                if let error = error {
                    print("Error adding project: \(error.localizedDescription)")
                    return
                }
                self.projectEditDelegate?.projectEdit(controller: self)
            }
        } else {
            showLoader(true)
            ProjectService.updateProject(id: documentId , title: title, description: description, technologies: technologies) { error in
                self.showLoader(false)
                if let error = error {
                    print("Error adding experience: \(error.localizedDescription)")
                    return
                }
                self.projectEditDelegate?.projectEdit(controller: self)
            }
        }
    }
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension EditProfileProjectController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension EditProfileProjectController: EditProfileProjectNameDelegate {
    func continueNextPage(controller: EditProfileProjectNameController) {
        self.projectName = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension EditProfileProjectController: EditProfileProjectDescriptionDelegate {
    func continueNextPage(controller: EditProfileProjectDescriptionController) {
        self.projectDescription = controller.keyTextField.text
        self.goToNextPage()
    }
}

extension EditProfileProjectController: EditProfileProjectTechnologiesDelegate {
    func continueNextPage(controller: EditProfileProjectTechnologiesController) {
        self.projectTechnologies = controller.keyTextField.text
        self.saveTapped()
    }
}
