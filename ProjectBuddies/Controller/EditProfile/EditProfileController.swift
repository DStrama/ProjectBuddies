//
//  EditProfileController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//

import UIKit

private let reuseIdentifierEditExperienceCell = "ProfileEditExperienceCell"
private let reuseIdentifierEditPhotoCell = "ProfileEditPhotoCell"
private let reuseIdentifierEditTextCell = "ProfileEditTextCell"
private let reuseIdentifierEditProjectCell = "ProfileEditProjectCell"

protocol EditedDelegate: class {
    func editedFields(controller: EditProfileController)
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties

    var user: User?
    
    var experiences = [Experience]()
    var projects = [Project]()
    var softSkills = [String]()
    var hardSkills = [String]()
    var hobbies = [String]()
    
    var delegate: EditedDelegate?
    
    private var headers: [String] = ["Profile", "Name", "About me", "Experience", "Projects", "Soft skills", "Hard skills", "Hobbies"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
//        fetchProperites()
    }
    
    // MARK: - Helpers
    
    private func handleRefreshExperience() {
        experiences.removeAll()
        fetchExperience()
    }
    
    private func handleRefreshProjects() {
        projects.removeAll()
        fetchProjects()
    }
    
    private func fetchUser() {
        UserService.fetchCurrentUser { user in
            self.user = user
            self.hardSkills = user.hardskills
            self.softSkills = user.softskills
            self.hobbies = user.hobbies
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func fetchProjects() {
        ProjectService.fetchProjects(userId: user!.uid) { projects in
            self.projects = projects
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func fetchExperience() {
        ExperienceService.fetchExperiences(userId: user!.uid) { experiences in
            self.experiences = experiences
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = K.Color.veryLightGray
        tableView.register(ProfileEditExperienceCell.self, forCellReuseIdentifier: reuseIdentifierEditExperienceCell)
        tableView.register(ProfileEditPhotoCell.self, forCellReuseIdentifier: reuseIdentifierEditPhotoCell)
        tableView.register(ProfileEditTextCell.self, forCellReuseIdentifier: reuseIdentifierEditTextCell)
        tableView.register(ProfileEditProjectCell.self, forCellReuseIdentifier: reuseIdentifierEditProjectCell)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let dummyViewHeight = CGFloat(50)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    
    private func setupNavigationBar() {
        let imageBack = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: imageBack, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.title = "Edit profile"
    }

    // MARK: - Actions
    
    @objc func doneTapped() {
        self.delegate!.editedFields(controller: self)
    }
    
    @objc func cancelTapped() {
        self.delegate!.editedFields(controller: self)
    }
    
    // MARK: - API
    
    private func fetchProperites() {
        fetchProjects()
        fetchUser()
        fetchExperience()
    }
}

extension EditProfileController {
    
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return experiences.count
        case 4:
            return projects.count
        case 5:
            return softSkills.count
        case 6:
            return hardSkills.count
        case 7:
            return hobbies.count
        default:
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditPhotoCell, for: indexPath) as! ProfileEditPhotoCell
            cell.viewModel = ProfileHeaderViewModel(user: user!)
            cell.delegateEditPhoto = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            cell.delegateEdit = self
            cell.settingProperties(text: user!.fullname, header: headers[section])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            cell.delegateEdit = self
            cell.settingProperties(text: user!.aboutme, header: headers[section])
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditExperienceCell, for: indexPath) as! ProfileEditExperienceCell
            cell.viewModel = ExperienceViewModel(experience: experiences[indexPath.row])
            cell.delegateEdit = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditProjectCell, for: indexPath) as! ProfileEditProjectCell
            cell.viewModel = ProjectViewModel(project: projects[indexPath.row])
            cell.delegateEdit = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            cell.settingProperties(text: softSkills[indexPath.row], header: headers[section])
            cell.delegateEdit = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            cell.settingProperties(text: hardSkills[indexPath.row], header: headers[section])
            cell.delegateEdit = self
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            cell.settingProperties(text: hobbies[indexPath.row], header: headers[section])
            cell.delegateEdit = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierEditTextCell, for: indexPath) as! ProfileEditTextCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        case 1...2:
            let header = ProfileEditHeaderWithoutAdding()
            header.settingProperties(title: headers[section])
            return header
        default:
            let header = ProfileEditHeaderSection()
            header.settingProperties(title: headers[section], typeButton: "plus", sectionArg: section, indexPathRowArg: 1)
            header.delegateElement = self
            return header
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {return 0}
        return 56
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if indexPath.section == 3 {
                ExperienceService.updateUserRoomsAfterRemovingRoom(experienceId: self.experiences[indexPath.row].experienceId)
                self.experiences.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if indexPath.section == 4 {
                ProjectService.updateUserRoomsAfterRemovingRoom(projectId: self.projects[indexPath.row].projectId)
                self.projects.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if indexPath.section == 5 {
                let updated = self.softSkills.filter { $0 != self.softSkills[indexPath.row] }
                UserService.updateUser(field: "softskills", value: updated) { error in
                    if let error = error {
                        print("Error updated document: \(error)")
                    } else {
                        self.softSkills = updated
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            if indexPath.section == 6 {
                let updated = self.hardSkills.filter { $0 != self.hardSkills[indexPath.row] }
                UserService.updateUser(field: "hardskills", value: updated) { error in
                    if let error = error {
                        print("Error updated document: \(error)")
                    } else {
                        self.hardSkills = updated
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            if indexPath.section == 7 {
                let updated = self.hobbies.filter { $0 != self.hobbies[indexPath.row] }
                
                UserService.updateUser(field: "hobbies", value: updated) { error in
                    if let error = error {
                        print("Error updated document: \(error)")
                    } else {
                        self.hobbies = updated
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
        return action
    }
}

// MARK: - ImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction,cameraAction,cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let oryginalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            showLoader(true)
            UserService.updateUserImage(image: oryginalImage) { imageUrl, error in
                self.showLoader(false)
                if let error = error {
                    print("Error updating image: \(error.localizedDescription)")
                    return
                }
                self.user?.profileImageUrl = imageUrl
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EditProfileController: editPhotoDelegate {
    func editPhoto(header: ProfileEditPhotoCell) {
        showImagePickerControllerActionSheet()
    }
}

extension EditProfileController: addElementDelegate {
    func actionOnHeader(headerType header: String, sec: Int, idx: Int)  {
        switch header {
            case "Name":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.propertyTitle = "fullname"
                controller.characterLimit = 100
                controller.height = 40
                controller.setUpProperties(title: "Update your\nname", text: user!.fullname, type: "update", placeholder: "Write your name...")
                navigationController?.pushViewController(controller, animated: true)
            case "About me":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.propertyTitle = "aboutme"
                controller.characterLimit = 300
                controller.height = 150
                controller.setUpProperties(title: "Update your bio", text: user!.aboutme, type: "update", placeholder: "Write something about yourself...")
                navigationController?.pushViewController(controller, animated: true)
            case "Experience":
                let controller = EditProfileExperienceController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                controller.experienceEditDelegate = self
                controller.operationType = "add"
                navigationController?.pushViewController(controller, animated: true)
            case "Projects":
                let controller = EditProfileProjectController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                controller.projectEditDelegate = self
                controller.operationType = "add"
                navigationController?.pushViewController(controller, animated: true)
            case "Soft skills":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "softskills"
                controller.height = 40
                controller.setUpProperties(title: "Add your\nsoft skill", text: "", type: "append", placeholder: "Write your skill...")
                navigationController?.pushViewController(controller, animated: true)
            case "Hard skills":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "hardskills"
                controller.height = 40
                controller.setUpProperties(title: "Add your\nhard skill", text: "", type: "append", placeholder: "Write your skill...")
                navigationController?.pushViewController(controller, animated: true)
            case "Hobbies":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "hobbies"
                controller.height = 40
                controller.setUpProperties(title: "Add your\nhobby", text: "", type: "append", placeholder: "Write your hobby...")
                navigationController?.pushViewController(controller, animated: true)
            default:
                break
        }
    }
}

extension EditProfileController: textDelegate {

    func saveText(controller: SpecifyEditProfileController) {
        self.fetchUser()
        controller.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileController: EditExperienceDelegate {
    
    func exitExperienceCell(viewModel: ExperienceViewModel) {
        let controller = EditProfileExperienceController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.experienceEditDelegate = self
        controller.operationType = "update"
        controller.documentId = viewModel.id!
        controller.setUpProperties(title: viewModel.name!, company: viewModel.company!, description: viewModel.description!)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension EditProfileController: EditProjectDelegate {
    
    func exitProjectCell(viewModel: ProjectViewModel) {
        let controller = EditProfileProjectController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.projectEditDelegate = self
        controller.operationType = "update"
        controller.documentId = viewModel.id!
        controller.setUpProperties(title: viewModel.name!, description: viewModel.description!, technologies: viewModel.technologies)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension EditProfileController: ProjectEditDelegate {
    func projectEdit(controller: EditProfileProjectController) {
        self.handleRefreshProjects()
        controller.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileController: ExprienceEditDelegate {
    
    func experienceEdit(controller: EditProfileExperienceController) {
        self.handleRefreshExperience()
        controller.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileController: EditTextDelegate {
    func exitTextCell(text: String, header: String) {
        switch header {
            case "Name":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.propertyTitle = "fullname"
                controller.characterLimit = 100
                controller.height = 40
                controller.setUpProperties(title: "Update your\nname", text: text, type: "update", placeholder: "Write your name...")
                navigationController?.pushViewController(controller, animated: true)
            case "About me":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.propertyTitle = "aboutme"
                controller.characterLimit = 300
                controller.height = 150
                controller.setUpProperties(title: "Update your bio", text: text, type: "update", placeholder: "Write something about yourself...")
                navigationController?.pushViewController(controller, animated: true)
            case "Soft skills":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "softskills"
                controller.height = 40
                controller.setUpProperties(title: "Add your\nsoft skill", text: text, type: "update", placeholder: "Write your skill...")
                navigationController?.pushViewController(controller, animated: true)
            case "Hard skills":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "hardskills"
                controller.height = 40
                controller.setUpProperties(title: "Add your\nhard skill", text: text, type: "update", placeholder: "Write your skill...")
                navigationController?.pushViewController(controller, animated: true)
            case "Hobbies":
                let controller = SpecifyEditProfileController()
                controller.delegateSaveText = self
                controller.characterLimit = 100
                controller.propertyTitle = "hobbies"
                controller.height = 40
                controller.setUpProperties(title: "Add your hobby", text: text, type: "update", placeholder: "Write your hobby...")
                navigationController?.pushViewController(controller, animated: true)
            default:
                break
        }
    }
}
