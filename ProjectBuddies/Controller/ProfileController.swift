//
//  ProfileViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import UIKit


private let headerIdentifier = "ProfileHeader"
private let headerPropertyIdentifier = "ProfilePropertyHeader"
private let experienceIdentifier = "ProfileExperienceCell"
private let projectIdentifier = "ProfileProjectCell"
private let textIdentifier = "ProfileTextCell"

protocol ProfileDelegate: AnyObject {
    func editedFields(controller: ProfileController)
}

class ProfileController: UITableViewController {

    // MARK: - Properties

    var delegate: ProfileDelegate?

    var user: User {
        didSet {
            self.fetchProperites()
        }
    }

    private var experiences = [Experience]()
    private var projects = [Project]()
    private var softSkills = [String]()
    private var hardSkills = [String]()
    private var hobbies = [String]()

    private var headers: [String] = ["Profile", "About me", "Experience", "Projects", "Soft skills", "Hard skills", "Hobbies"]

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        self.hardSkills = user.hardskills
        self.softSkills = user.softskills
        self.hobbies = user.hobbies

        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupNavigationBar()
        fetchProperites()
    }

    // MARK: - API

    private func fetchProperites() {
        fetchProjects()
//        fetchUser()
        fetchExperience()
    }

    private func fetchUser() {
        UserService.fetchUser(userId: user.uid) { user in
            self.user = user
            self.hardSkills = user.hardskills
            self.softSkills = user.softskills
            self.hobbies = user.hobbies

            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }


    private func fetchProjects() {
        self.projects.removeAll()
        ProjectService.fetchProjects(userId: user.uid) { projects in
            self.projects = projects
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func fetchExperience() {
        self.projects.removeAll()
        ExperienceService.fetchExperiences(userId: user.uid) { experiences in
            self.experiences = experiences
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func configureCollectionView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = K.Color.lighterCreme
        tableView.register(ProfileExperienceCell.self, forCellReuseIdentifier: experienceIdentifier)
        tableView.register(ProfileProjectCell.self, forCellReuseIdentifier: projectIdentifier)
        tableView.register(ProfileTextCell.self, forCellReuseIdentifier: textIdentifier)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
    }

    private func setupNavigationBar() {
        let image = UIImage(systemName: "ellipsis")
        image?.withTintColor(K.Color.black)
        let settingsBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openSettings))
        settingsBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.rightBarButtonItem = settingsBarButtonItem

        let imageBack = UIImage(systemName: "chevron.left")
        let backBarButtonItem = UIBarButtonItem(image: imageBack, style: .plain, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem

        navigationItem.title = "Profile"
    }

    // MARK: - Actions

    @objc func openSettings() {
        let controller = SettingsController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - UICollectionViewDataSource

extension ProfileController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            if user.aboutme.isEmpty { return 0 }
            return 1
        case 2:
            return experiences.count
        case 3:
            return projects.count
        case 4:
            return softSkills.count
        case 5:
            return hardSkills.count
        case 6:
            return hobbies.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier, for: indexPath) as! ProfileTextCell
            cell.setUpProperty(text: user.aboutme)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: experienceIdentifier, for: indexPath) as! ProfileExperienceCell
            cell.viewModel = ExperienceViewModel(experience: experiences[indexPath.row])
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: projectIdentifier, for: indexPath) as! ProfileProjectCell
            cell.viewModel = ProjectViewModel(project: projects[indexPath.row])
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier, for: indexPath) as! ProfileTextCell
            cell.setUpProperty(text: softSkills[indexPath.row])
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier, for: indexPath) as! ProfileTextCell
            cell.setUpProperty(text: hardSkills[indexPath.row])
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier, for: indexPath) as! ProfileTextCell
            cell.setUpProperty(text: hobbies[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier, for: indexPath) as! ProfileTextCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = ProfileHeader()
            header.viewModel = ProfileHeaderViewModel(user: user)
            header.editOrMessageDelegate = self
            return header
        case 1:
            if user.aboutme.count == 0 {
                return nil
            }
            let header = ProfilePropertyHeader()
            header.settingProperty(title: headers[section])
            return header
        case 2:
            if experiences.count == 0 {
                return nil
            } else {
                let header = ProfilePropertyHeader()
                header.settingProperty(title: headers[section])
                return header
            }
        case 3:
            if projects.count == 0 {
                return nil
            } else {
                let header = ProfilePropertyHeader()
                header.settingProperty(title: headers[section])
                return header
            }
        case 4:
            if softSkills.count == 0 {
                return nil
            } else {
                let header = ProfilePropertyHeader()
                header.settingProperty(title: headers[section])
                return header
            }
        case 5:
            if hardSkills.count == 0 {
                return nil
            } else {
                let header = ProfilePropertyHeader()
                header.settingProperty(title: headers[section])
                return header
            }
        case 6:
            if hobbies.count == 0 {
                return nil
            } else {
                let header = ProfilePropertyHeader()
                header.settingProperty(title: headers[section])
                return header
            }
        default:
            return nil
        }

//        switch section {
//        case 0:
//            let header = ProfileHeader()
//            header.viewModel = ProfileHeaderViewModel(user: user)
//            header.editOrMessageDelegate = self
//            return header
//        default:
//            let header = ProfilePropertyHeader()
//            header.settingProperty(title: headers[section])
//            return header
//        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 196
        case 1:
            if user.aboutme.count == 0 {
                return 0
            }
            return 32
        case 2:
            if experiences.count == 0 {
                return 0
            }
            return 32
        case 3:
            if projects.count == 0 {
                return 0
            }
            return 32
        case 4:
            if softSkills.count == 0 {
                return 0
            }
            return 32
        case 5:
            if hardSkills.count == 0 {
                return 0
            }
            return 32
        case 6:
            if hobbies.count == 0 {
                return 0
            }
            return 32
        default:
            return 32
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController: ButtonDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {

        if user.isCurrentUser {
            let controller = EditProfileController()
            controller.user = user
            controller.experiences = experiences
            controller.projects = projects
            controller.softSkills = softSkills
            controller.hardSkills = hardSkills
            controller.hobbies = hobbies
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = ChatController()
            controller.currentUser = self.user
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension ProfileController: EditedDelegate {

    func editedFields(controller: EditProfileController) {
        user = controller.user!
        projects = controller.projects
        experiences = controller.experiences
        hobbies = controller.hobbies
        softSkills = controller.softSkills
        hardSkills = controller.hardSkills
        self.tableView.reloadData()
        controller.navigationController?.popViewController(animated: true)
        delegate?.editedFields(controller: self)
    }

}
