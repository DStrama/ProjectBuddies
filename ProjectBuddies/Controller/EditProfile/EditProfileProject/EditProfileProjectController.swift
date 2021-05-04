//
//  EditProfileAddProjectController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit

protocol ProjectEditDelegate: class {
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
        
//        removeSwipeGesture()
        
        self.view.addSubview(self.pageControl)
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
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
            print(documentId)
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


//protocol ProjectEditDelegate: class {
//    func projectEdit(controller: EditProfileProjectController)
//}
//
//class EditProfileProjectController: UIViewController {
//
//    // MARK: - Properties
//
//    var section = 0
//
//    var projectEditDelegate: ProjectEditDelegate?
//
//    var operationType: String = String()
//
//    var documentId: String = String()
//
//    private var titleLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "Title"
//        return l
//    }()
//
//    private var titleTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "Ex: Health tracker", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//
//    private var descriptionLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "Description"
//        return l
//    }()
//
//    private var descriptionTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//
//    private var technologiesLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "Technologies"
//        return l
//    }()
//
//    private var technologiesTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "Ex: Swift, Firebase", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigationBar()
//        setUpViewsAndConstraints()
//    }
//
//    // MARK: - Helpers
//
//    private func setupNavigationBar() {
//        let image = UIImage(systemName: "chevron.left")
//        image?.withTintColor(K.Color.black)
//        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
//        navigationItem.leftBarButtonItem = backBarButtonItem
//
//        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
//        navigationItem.rightBarButtonItem = saveBarButtonItem
//    }
//
//    private func setUpViewsAndConstraints() {
//        view.backgroundColor = K.Color.white
//
//        view.addSubview(titleLabel)
//        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//        view.addSubview(titleTextField)
//        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//        view.addSubview(descriptionLabel)
//        descriptionLabel.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//        view.addSubview(descriptionTextField)
//        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//        view.addSubview(technologiesLabel)
//        technologiesLabel.anchor(top: descriptionTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//        view.addSubview(technologiesTextField)
//        technologiesTextField.anchor(top: technologiesLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//    }
//
//    func setUpProperties(title: String, description: String, technologies: String) {
//        titleTextField.text = title
//        descriptionTextField.text = description
//        technologiesTextField.text = technologies
//    }
//
//    // MARK: - Actions
//
//    @objc func cancelTapped() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @objc func saveTapped() {
//        guard let title = titleTextField.text else { return }
//        guard let description = descriptionTextField.text else { return }
//        guard let technologies = technologiesTextField.text else { return }
//
//        if (operationType == "add") {
//            showLoader(true)
//            ProjectService.uploadProject(title: title, description: description, technologies: technologies) { error in
//                self.showLoader(false)
//                if let error = error {
//                    print("Error adding project: \(error.localizedDescription)")
//                    return
//                }
//                self.projectEditDelegate?.projectEdit(controller: self)
//            }
//        } else {
//            showLoader(true)
//            print(documentId)
//            ProjectService.updateProject(id: documentId , title: title, description: description, technologies: technologies) { error in
//                self.showLoader(false)
//                if let error = error {
//                    print("Error adding experience: \(error.localizedDescription)")
//                    return
//                }
//                self.projectEditDelegate?.projectEdit(controller: self)
//            }
//        }
//    }
//
//}
