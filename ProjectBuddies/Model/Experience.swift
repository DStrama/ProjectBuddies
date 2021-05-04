//
//  Experience.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct Experience {
    var title: String
    var company: String
    var description: String
    var timestamp: Timestamp
    let owner: String
    let experienceId: String
    
    init(experienceId: String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.company = dictionary["company"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.owner = dictionary["owner"] as? String ?? ""
        self.experienceId = experienceId 
    }
}

