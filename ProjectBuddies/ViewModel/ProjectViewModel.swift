//
//  ProjectViewModel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct ProjectViewModel {
    
    private let project: Project
    
    var name: String? {
        return project.title
    }
    
    var description: String? {
        return project.description
    }
    
    var technologies: String {
        return project.technologies
    }
    
    var id: String? {
        return project.projectId
    }
    
    init(project: Project) {
        self.project = project
    }
}
