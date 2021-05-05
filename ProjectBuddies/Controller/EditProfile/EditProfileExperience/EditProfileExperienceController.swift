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
//
//
////
////  EditProfilleAddExperienceController.swift
////  ProjectBuddies
////
////  Created by Dominik Strama on 12/03/2021.
////
//
//import UIKit
//import MultilineTextField
//
//protocol ExprienceEditDelegate: class {
//    func experienceEdit(controller: EditProfileExperienceController)
//}
//
//class EditProfileExperienceController: UIViewController, UITextFieldDelegate {
//    
//    // MARK: - Properties
//
//    var experienceEditDelegate: ExprienceEditDelegate?
//    
//    var data = ["full-time", "part-time"]
//    
//    var operationType: String = String()
//    
//    var documentId: String = String()
//    
//    private var titleLabel: UILabel = {
//        let l = UILabel()
//        l.textAlignment = .center
//        l.text = "Title"
//        l.numberOfLines = 0
//        l.font = K.Font.header
//        l.textAlignment = .left
//        return l
//    }()
//
//    private var titleTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "Ex: Software Engineer", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//    
//    private var companyLabel: UILabel = {
//        let l = UILabel()
//        l.textAlignment = .center
//        l.text = "Company"
//        l.numberOfLines = 0
//        l.font = K.Font.header
//        l.textAlignment = .left
//        return l
//    }()
//
//    private var companyTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "Ex: Microsoft", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//    
//    private var currentRoleButton: UIButton = {
//        var btn = UIButton()
//        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//        btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
//        return btn
//    }()
//    
//    private var currentRoleLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "I am currently working in this role"
//        return l
//    }()
//    
//    private var descriptionLabel: UILabel = {
//        let l = UILabel()
//        l.textAlignment = .center
//        l.text = "Description"
//        l.numberOfLines = 0
//        l.font = K.Font.header
//        l.textAlignment = .left
//        return l
//    }()
//    
//    private var descriptionTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//    
//    private var startDateLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "Start date"
//        return l
//    }()
//    
//    private var endDateLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "End date"
//        return l
//    }()
//
//    private let startDatePicker: UIDatePicker = {
//        var dp = UIDatePicker()
//        dp.timeZone = NSTimeZone.local
//        dp.backgroundColor = UIColor.white
//        dp.datePickerMode = UIDatePicker.Mode.date
//        return dp
//    }()
//    
//    private let endDatePicker: UIDatePicker = {
//        var dp = UIDatePicker()
//        dp.timeZone = NSTimeZone.local
//        dp.backgroundColor = UIColor.white
//        dp.datePickerMode = UIDatePicker.Mode.date
//        return dp
//    }()
//
//    private var picker = UIPickerView()
//
//    private var employmentTypeLabel: CustomLabel = {
//        var l = CustomLabel(fontType: K.Font.regular!)
//        l.text = "Employment Type"
//        return l
//    }()
//
//    private var employmentTypeTextField: UITextField = {
//        var tf = CustomTextField(placeholder: "-", txtColor: K.Color.black, bgColor: K.Color.clear)
//        return tf
//    }()
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpPicker()
//        setupNavigationBar()
//        setUpViewsAndConstraints()
//        setUpDataPicker()
//    }
//    
//    // MARK: - Helpers
//    
//    func setUpProperties(title: String, company: String, employmentType: String, description: String) {
//        titleTextField.text = title
//        companyTextField.text = company
//        employmentTypeTextField.text = employmentType
//        descriptionTextField.text = description
//    }
//    
//    private func setUpViewsAndConstraints() {
//        view.backgroundColor = K.Color.lighterCreme
//
//        view.addSubview(titleLabel)
//        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)
//
//        view.addSubview(titleTextField)
//        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//        
//        view.addSubview(companyLabel)
//        companyLabel.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//        
//        view.addSubview(companyTextField)
//        companyTextField.anchor(top: companyLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//    
//        view.addSubview(descriptionLabel)
//        descriptionLabel.anchor(top: companyTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//        
//        view.addSubview(descriptionTextField)
//        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
//
//    }
//    
//    private func setUpDataPicker() {
//        startDatePicker.addTarget(self, action: #selector(EditProfileExperienceController.datePickerValueChanged(_:)), for: .valueChanged)
//    }
//    
//    private func setupNavigationBar() {
//        let image = UIImage(systemName: "chevron.left")
//        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
//        backBarButtonItem.tintColor = K.Color.navyApp
//        navigationItem.leftBarButtonItem = backBarButtonItem
//        
//        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
//        saveBarButtonItem.tintColor = K.Color.navyApp
//        navigationItem.rightBarButtonItem = saveBarButtonItem
//    }
//    
//    private func setUpPicker() {
//        picker.delegate = self
//        picker.dataSource = self
//        employmentTypeTextField.delegate = self
//        employmentTypeTextField.inputView = picker
//        picker.isHidden = true
//    }
//    
//    // MARK: - Actions
//    
//    @objc private func cancelTapped() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @objc private func saveTapped() {
//        guard let title = titleTextField.text else { return }
//        guard let company = companyTextField.text else { return }
//        guard let description = descriptionTextField.text else { return }
//        
//        if (operationType == "add") {
//            showLoader(true)
//            ExperienceService.uploadExperience(title: title, company: company, description: description) { error in
//                self.showLoader(false)
//                if let error = error {
//                    print("Error adding experience: \(error.localizedDescription)")
//                    return
//                }
//                self.experienceEditDelegate?.experienceEdit(controller: self)
//            }
//        } else {
//            showLoader(true)
//            ExperienceService.updateExperience(id: documentId , title: title, company: company, description: description) { error in
//                self.showLoader(false)
//                if let error = error {
//                    print("Error adding experience: \(error.localizedDescription)")
//                    return
//                }
//                self.experienceEditDelegate?.experienceEdit(controller: self)
//            }
//        }
//    }
//    
//    @objc private func datePickerValueChanged(_ sender: UIDatePicker){
//          
//          let dateFormatter: DateFormatter = DateFormatter()
//          dateFormatter.dateFormat = "MM/dd/yyyy"
//          
//          let selectedDate: String = dateFormatter.string(from: sender.date)
//          
//          print("Selected value \(selectedDate)")
//    }
//}
//
//extension EditProfileExperienceController: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return data.count
//    }
//
//    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return data[row]
//    }
//
//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        employmentTypeTextField.text = data[row]
//        picker.isHidden = true
//    }
//    
//}
