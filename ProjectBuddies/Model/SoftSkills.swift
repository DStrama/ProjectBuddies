//
//  softSkills.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct SoftSkills {
    var title: String
    var timestamp: Timestamp
    let owner: String
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.owner = dictionary["owner"] as? String ?? ""
    }
}
