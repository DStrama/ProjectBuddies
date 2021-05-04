//
//  Project.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct Project {
    var title: String
    var description: String
    var technologies: String
    var timestamp: Timestamp
    let owner: String
    let projectId: String
    
    init(projectId: String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.technologies = dictionary["technologies"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.owner = dictionary["owner"] as? String ?? ""
        self.projectId = projectId
    }
}
