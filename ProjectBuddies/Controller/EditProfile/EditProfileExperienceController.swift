//
//  EditProfilleAddExperienceController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 12/03/2021.
//

import UIKit
import MultilineTextField

protocol ExprienceEditDelegate: class {
    func experienceEdit(controller: EditProfileExperienceController)
}

class EditProfileExperienceController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    var experienceEditDelegate: ExprienceEditDelegate?
    
    var data = ["full-time", "part-time"]
    
    var operationType: String = String()
    
    var documentId: String = String()
    
    private var titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Title"
        l.numberOfLines = 0
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()

    private var titleTextField: UITextField = {
        var tf = CustomTextField(placeholder: "Ex: Software Engineer", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
    }()
    
    private var companyLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Company"
        l.numberOfLines = 0
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()

    private var companyTextField: UITextField = {
        var tf = CustomTextField(placeholder: "Ex: Microsoft", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
    }()
    
    private var currentRoleButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        return btn
    }()
    
    private var currentRoleLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "I am currently working in this role"
        return l
    }()
    
    private var descriptionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "Description"
        l.numberOfLines = 0
        l.font = K.Font.header
        l.textAlignment = .left
        return l
    }()
    
    private var descriptionTextField: UITextField = {
        var tf = CustomTextField(placeholder: "", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
    }()
    
    private var startDateLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Start date"
        return l
    }()
    
    private var endDateLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "End date"
        return l
    }()

    private let startDatePicker: UIDatePicker = {
        var dp = UIDatePicker()
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = UIColor.white
        dp.datePickerMode = UIDatePicker.Mode.date
        return dp
    }()
    
    private let endDatePicker: UIDatePicker = {
        var dp = UIDatePicker()
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = UIColor.white
        dp.datePickerMode = UIDatePicker.Mode.date
        return dp
    }()

    private var picker = UIPickerView()

    private var employmentTypeLabel: CustomLabel = {
        var l = CustomLabel(fontType: K.Font.regular!)
        l.text = "Employment Type"
        return l
    }()

    private var employmentTypeTextField: UITextField = {
        var tf = CustomTextField(placeholder: "-", txtColor: K.Color.black, bgColor: K.Color.clear)
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        setupNavigationBar()
        setUpViewsAndConstraints()
        setUpDataPicker()
    }
    
    // MARK: - Helpers
    
    func setUpProperties(title: String, company: String, employmentType: String, description: String) {
        titleTextField.text = title
        companyTextField.text = company
        employmentTypeTextField.text = employmentType
        descriptionTextField.text = description
    }
    
    private func setUpViewsAndConstraints() {
        view.backgroundColor = K.Color.lighterCreme

        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 48, paddingLeft: 56)

        view.addSubview(titleTextField)
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(companyLabel)
        companyLabel.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(companyTextField)
        companyTextField.anchor(top: companyLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: companyTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(descriptionTextField)
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

    }
    
    private func setUpDataPicker() {
        startDatePicker.addTarget(self, action: #selector(EditProfileExperienceController.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        saveBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    private func setUpPicker() {
        picker.delegate = self
        picker.dataSource = self
        employmentTypeTextField.delegate = self
        employmentTypeTextField.inputView = picker
        picker.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text else { return }
        guard let company = companyTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker){
          
          let dateFormatter: DateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"
          
          let selectedDate: String = dateFormatter.string(from: sender.date)
          
          print("Selected value \(selectedDate)")
    }
}

extension EditProfileExperienceController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employmentTypeTextField.text = data[row]
        picker.isHidden = true
    }
    
}
